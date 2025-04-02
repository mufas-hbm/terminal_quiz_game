import psycopg2

class DatabaseManager:
    def __init__(self, dbname, user, password, host, port):
        self.dbname = dbname
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.conn = None

    def connect(self):
        try:
            self.conn = psycopg2.connect(
                dbname=self.dbname,
                user=self.user,
                password=self.password,
                host=self.host,
                port=self.port
            )
        except Exception as e:
            print("Error connecting to the database:", e)

    def close(self):
        try:
            if self.conn:
                self.conn.close()
        except Exception as e:
            print("Error closing the database:", e)
    
    def fetch_submodules_add_questions(self):
        """
        Fetches a list of submodule names from the 'submodules' table in the database.

        This method establishes a database connection, executes a query to retrieve
        all submodule names, and returns the results as a list. In case of an error
        (e.g., connection failure or query issue), it catches the exception and returns
        an empty list.

        Returns:
            list: A list of submodule names fetched from the database. Returns an 
                empty list if an error occurs during database interaction.
        """
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                query = """
                    SELECT submodule_name
                    FROM submodules;
                """
                cursor.execute(query)  # Add a trailing comma to make it a tuple
                submodules = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
            return submodules
        except Exception as e:
            print("Error fetching submodules:", e)
            return []  # Return an empty list in case of error

    def fetch_submodules_from_module(self, module=None):
        """
        Fetches a list of submodule names from the 'submodules' table in the database.

        This method establishes a database connection, executes a query to retrieve
        all submodule names, and returns the results as a list. In case of an error
        (e.g., connection failure or query issue), it catches the exception and returns
        an empty list.

        Returns:
            list: A list of submodule names fetched from the database. Returns an 
                empty list if an error occurs during database interaction.
        """
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                query = """
                    SELECT submodule_name
                    FROM submodules 
                    JOIN modules 
                    ON modules.module_id = submodules.module_id 
                    WHERE module_name = %s;
                """
                cursor.execute(query, (module,))  # Add a trailing comma to make it a tuple
                submodules = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
            return submodules
        except Exception as e:
            print("Error fetching submodules:", e)
            return []  # Return an empty list in case of error

    
    def fetch_modules(self, topic):
        """
        Fetches a list of module names from the modules' table in the database.

        Args:
            topic (str): The name of the topic to fetch modules for.

        Returns:
            list: A list of module names fetched from the database.
                Returns an empty list if an error occurs during database interaction.
        """
        try:
            with self.conn.cursor() as cursor:
                query = """
                    SELECT module_name 
                    FROM modules 
                    JOIN topics ON modules.topic_id = topics.topic_id 
                    WHERE topics.topic_name = %s;
                """
                cursor.execute(query, (topic,))  # Pass arguments as a tuple
                modules = [row[0] for row in cursor.fetchall()]
            return modules
        except Exception as e:
            print(f"Error fetching modules: {e}")
            return []  # Return an empty list in case of error

    
    def fetch_topics(self):
        """
        Fetches a list of topic names from the topics table in the database.

        This method establishes a database connection, executes a query to retrieve
        all topic names, and returns the results as a list. In case of an error
        (e.g., connection failure or query issue), it catches the exception and returns
        an empty list.

        Returns:
            list: A list of topic names fetched from the database. Returns an 
                empty list if an error occurs during database interaction.
        """
        try:
            with self.conn.cursor() as cursor:  
                query = "SELECT topic_name FROM topics;"
                cursor.execute(query)
                topics = [row[0] for row in cursor.fetchall()]  #
            return topics
        except Exception as e:
            print("Error fetching topics:", e)
            return []  # Return an empty list in case of error
        
    def fetch_questions(self, user_choice):
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                if user_choice is None:
                    query = "SELECT question_text FROM questions WHERE submodule_id IS NULL;"
                    cursor.execute(query)
                else:
                    query = "SELECT question_text FROM questions JOIN submodules ON submodules.submodule_id=questions.submodule_id WHERE submodule_name=%s;"
                    cursor.execute(query,(user_choice,))
                questions = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
            return questions
        except Exception as e:
            print("Error fetching questions:", e)
            return []  # Return an empty list in case of error
    
    def fetch_answers_from_question(self, question):
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                query = "SELECT answer FROM answers JOIN questions ON answers.question_id=questions.question_id WHERE question_text=%s;"
                cursor.execute(query,(question,))
                answers = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
            return answers
        except Exception as e:
            print("Error fetching questions:", e)
            return []  # Return an empty list in case of error

    def get_choice(self, category, id, parent_id=None):
        """
        Fetches the name for the given category and IDs from the database.

        Args:
            category (str): The category to fetch (e.g., "topic", "module", "submodule").
            id (int): The ID of the category.
            parent_id (int, optional): The parent ID for hierarchical relationships.

        Returns:
            list: A list of names fetched from the database, or None on failure.
        """
        try:
            with self.conn.cursor() as cursor:
                if parent_id:
                    # Define parent column based on category
                    parent_column = "topic_id" if category == "module" else "module_id" if category == "submodule" else None
                    if parent_column:
                        query = f"""
                            SELECT {category}_name
                            FROM {category}s
                            WHERE {category}_id = %s AND {parent_column} = %s;
                        """
                        cursor.execute(query, (id, parent_id))
                else:
                    query = f"SELECT {category}_name FROM {category}s WHERE {category}_id = %s;"
                    cursor.execute(query, (id,))
                
                output = [row[0] for row in cursor.fetchall()]
                return output
        except Exception as e:
            print(f"Error fetching {category}: {e}")
            return None
        
    def check_user_answer(self, user_answer):
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                query = "SELECT right_answer FROM answers WHERE answer=%s;"
                print(query)
                cursor.execute(query,(user_answer, ))
                answer = cursor.fetchone()[0]
            return answer
        except Exception as e:
            print("Error fetching questions:", e)
            return []  # Return an empty list in case of error

    def create_database_dict(self):
        db_dict = {}
        try:
            topics = self.fetch_topics()
            if not topics:
                return {}  # Return empty dictionary if no topics found

            for topic_index, topic in enumerate(topics, start=1):
                topic_data = {"name": topic, "modules": {}}
                modules = self.fetch_modules(topic)

                if modules:
                    for module_index, module in enumerate(modules, start=1):
                        module_data = {"name": module, "submodules": []}
                        submodules = self.fetch_submodules_from_module(module)

                        if submodules:
                            for submodule_index, submodule in enumerate(submodules, start=1):
                                module_data["submodules"].append({"name": submodule, "index": submodule_index})
                        topic_data["modules"][module_index] = module_data

                db_dict[topic_index] = topic_data

            return db_dict

        except Exception as e:
            print(f"Error creating topics dictionary: {e}")
            return {}  # Return empty dictionary in case of error
