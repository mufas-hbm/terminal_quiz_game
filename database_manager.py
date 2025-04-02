import psycopg2
import logging

class DatabaseManager:
    def __init__(self, dbname, user, password, host, port):
        """
        Initializes the database connection parameters.

        Stores the provided credentials and connection details for establishing
        a connection to the PostgreSQL database.

        Args:
            dbname (str): Name of the database.
            user (str): Username for database authentication.
            password (str): Password for database authentication.
            host (str): Database server host address.
            port (int): Port number for database connection.

        Attributes:
            conn (NoneType): Placeholder for the database connection, initially set to None.
        """
        self.dbname = dbname
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.conn = None

    def connect(self):
        """
        Establishes a connection to the PostgreSQL database.

        Uses the provided database credentials to initiate a connection.
        If an error occurs during connection, logs an error message.

        Raises:
            Exception: Logs an error message if connecting to the database fails.
        """
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
        """
        Closes the database connection if it exists.

        Ensures that the database connection is safely closed to free up resources.
        If an error occurs during closing, it logs an error message.

        Raises:
            Exception: Logs an error message if closing the connection fails.
        """
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

    
    def fetch_data(self, query, params=()):
        """Executes a SQL query and returns results as a list."""
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, params)
                return [row[0] for row in cursor.fetchall()]
        except Exception as e:
            logging.error(f"Database query failed: {e}")
            return []  # Return empty list on failure
    
    def fetch_topics(self):
        """Fetch topics dynamically."""
        return self.fetch_data("SELECT topic_name FROM topics;")

    def fetch_modules(self, topic):
        """Fetch modules related to a topic."""
        query = """
            SELECT module_name 
            FROM modules 
            JOIN topics ON modules.topic_id = topics.topic_id 
            WHERE topics.topic_name = %s;
        """
        return self.fetch_data(query, (topic,))
    
    def fetch_submodules(self, module):
        """Fetch submodules related to a module."""
        query = """
            SELECT submodule_name
                    FROM submodules 
                    JOIN modules 
                    ON modules.module_id = submodules.module_id 
                    WHERE module_name = %s;
        """
        return self.fetch_data(query, (module,))

    # def fetch_submodules_from_module(self, module=None):
    #     """
    #     Fetches a list of submodule names from the 'submodules' table in the database.

    #     This method establishes a database connection, executes a query to retrieve
    #     all submodule names, and returns the results as a list. In case of an error
    #     (e.g., connection failure or query issue), it catches the exception and returns
    #     an empty list.

    #     Returns:
    #         list: A list of submodule names fetched from the database. Returns an 
    #             empty list if an error occurs during database interaction.
    #     """
    #     try:
    #         with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
    #             query = """
    #                 SELECT submodule_name
    #                 FROM submodules 
    #                 JOIN modules 
    #                 ON modules.module_id = submodules.module_id 
    #                 WHERE module_name = %s;
    #             """
    #             cursor.execute(query, (module,))  # Add a trailing comma to make it a tuple
    #             submodules = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
    #         return submodules
    #     except Exception as e:
    #         print("Error fetching submodules:", e)
    #         return []  # Return an empty list in case of error

    
    # def fetch_modules(self, topic):
    #     """
    #     Fetches a list of module names from the modules' table in the database.

    #     Args:
    #         topic (str): The name of the topic to fetch modules for.

    #     Returns:
    #         list: A list of module names fetched from the database.
    #             Returns an empty list if an error occurs during database interaction.
    #     """
    #     try:
    #         with self.conn.cursor() as cursor:
    #             query = """
    #                 SELECT module_name 
    #                 FROM modules 
    #                 JOIN topics ON modules.topic_id = topics.topic_id 
    #                 WHERE topics.topic_name = %s;
    #             """
    #             cursor.execute(query, (topic,))  # Pass arguments as a tuple
    #             modules = [row[0] for row in cursor.fetchall()]
    #         return modules
    #     except Exception as e:
    #         print(f"Error fetching modules: {e}")
    #         return []  # Return an empty list in case of error

    
    # def fetch_topics(self):
    #     """
    #     Fetches a list of topic names from the topics table in the database.

    #     This method establishes a database connection, executes a query to retrieve
    #     all topic names, and returns the results as a list. In case of an error
    #     (e.g., connection failure or query issue), it catches the exception and returns
    #     an empty list.

    #     Returns:
    #         list: A list of topic names fetched from the database. Returns an 
    #             empty list if an error occurs during database interaction.
    #     """
    #     try:
    #         with self.conn.cursor() as cursor:  
    #             query = "SELECT topic_name FROM topics;"
    #             cursor.execute(query)
    #             topics = [row[0] for row in cursor.fetchall()]  #
    #         return topics
    #     except Exception as e:
    #         print("Error fetching topics:", e)
    #         return []  # Return an empty list in case of error
        
    # def fetch_questions(self, user_choice):
    #     try:
    #         with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
    #             if user_choice is None:
    #                 query = "SELECT question_text FROM questions WHERE submodule_id IS NULL;"
    #                 cursor.execute(query)
    #             else:
    #                 query = "SELECT question_text FROM questions JOIN submodules ON submodules.submodule_id=questions.submodule_id WHERE submodule_name=%s;"
    #                 cursor.execute(query,(user_choice,))
    #             questions = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
    #         return questions
    #     except Exception as e:
    #         print("Error fetching questions:", e)
    #         return []  # Return an empty list in case of error
    def fetch_questions(self, user_choice):
        if user_choice is None:
            query = "SELECT question_text FROM questions WHERE submodule_id IS NULL;"
        else:
            query = "SELECT question_text FROM questions JOIN submodules ON submodules.submodule_id=questions.submodule_id WHERE submodule_name=%s;"
        return self.fetch_data(query, (user_choice,))
    
    # def fetch_answers_from_question(self, question):
    #     """
    #     Retrieves all possible answers for a given question from the database.

    #     Args:
    #         question (str): The text of the question for which answers should be fetched.

    #     Returns:
    #         list: A list of answer choices related to the question.
    #             Returns an empty list if an error occurs or no answers are found.

    #     Raises:
    #         Exception: Logs an error message if fetching answers fails.
    #     """
    #     try:
    #         with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
    #             query = "SELECT answer FROM answers JOIN questions ON answers.question_id=questions.question_id WHERE question_text=%s;"
    #             cursor.execute(query,(question,))
    #             answers = [row[0] for row in cursor.fetchall()]  # Fetch all rows and extract submodule names
    #         return answers
    #     except Exception as e:
    #         print("Error fetching questions:", e)
    #         return []  # Return an empty list in case of error
    
    def fetch_answers_from_question(self, question):
        query = "SELECT answer FROM answers JOIN questions ON answers.question_id=questions.question_id WHERE question_text=%s;"
        return self.fetch_data(query, (question,)) 
               
    def check_user_answer(self, user_answer):
        """
        Checks whether the user's answer matches the correct answer stored in the database.

        Args:
            user_answer (str): The answer provided by the user.

        Returns:
            str: The correct answer if found in the database.
            list: An empty list if an error occurs during the query execution.

        Raises:
            Exception: Logs an error message if fetching the correct answer fails.
        """
        try:
            with self.conn.cursor() as cursor:  # Automatically closes the cursor after the queries
                query = "SELECT right_answer FROM answers WHERE answer=%s;"
                cursor.execute(query,(user_answer, ))
                answer = cursor.fetchone()[0]
            return answer
        except Exception as e:
            print("Error fetching questions:", e)
            return []  # Return an empty list in case of error

    # def create_database_dict(self):
    #     """
    #     Creates a nested dictionary structure representing topics, modules, and submodules.

    #     Args:
    #         db_manager: An instance of a database manager that provides methods to fetch topics, modules, and submodules.

    #     Returns:
    #         dict: A dictionary where each topic has associated modules and submodules.
    #             Returns an empty dictionary if no topics are found or an error occurs.
    #     """
    #     db_dict = {}
    #     try:
    #         topics = self.fetch_topics()
    #         if not topics:
    #             return {}  # Return empty dictionary if no topics found

    #         for topic_index, topic in enumerate(topics, start=1):
    #             topic_data = {"name": topic, "modules": {}}
    #             modules = self.fetch_modules(topic)

    #             if modules:
    #                 for module_index, module in enumerate(modules, start=1):
    #                     module_data = {"name": module, "submodules": []}
    #                     submodules = self.fetch_submodules(module)

    #                     if submodules:
    #                         for submodule_index, submodule in enumerate(submodules, start=1):
    #                             module_data["submodules"].append({"name": submodule, "index": submodule_index})
    #                     topic_data["modules"][module_index] = module_data

    #             db_dict[topic_index] = topic_data

    #         return db_dict

    #     except Exception as e:
    #         print(f"Error creating topics dictionary: {e}")
    #         return {}  # Return empty dictionary in case of error
    

    def get_data(self, level, parent=None):
        """Fetches relevant category data based on user selection."""
        if level == "topics":
            return self.fetch_topics()
        elif level == "modules" and parent:
            return self.fetch_modules(parent)
        elif level == "submodules" and parent:
            return self.fetch_submodules(parent)
        return []  # Default empty list for invalid inputs
