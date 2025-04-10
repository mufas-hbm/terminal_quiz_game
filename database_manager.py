import psycopg2
import logging

# Configure logging to write errors to a file
logging.basicConfig(
    filename='error.log',
    level=logging.ERROR,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

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
        query = """
                    SELECT submodule_name
                    FROM submodules;
                """
        return self.fetch_data(query)

    def fetch_data(self, query, params=()):
        """Executes a SQL query and returns results as a list."""
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, params)
                return [row[0] for row in cursor.fetchall()]
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
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
            
    def fetch_questions(self, user_choice):
        if user_choice is None:
            query = "SELECT question_text FROM questions WHERE submodule_id IS NULL;"
        else:
            query = "SELECT question_text FROM questions JOIN submodules ON submodules.submodule_id=questions.submodule_id WHERE submodule_name=%s;"
        return self.fetch_data(query, (user_choice,))
    
    def fetch_questions_difficulty_mode(self, difficulty):
        query = "SELECT question_text FROM questions WHERE difficulty=%s;"
        return self.fetch_data(query, (difficulty,))
    
    def fetch_answers_from_question(self, question):
        """
        Fetches one correct answer and three random wrong answers for a given question.

        This function retrieves a total of four answers (1 correct and 3 wrong) 
        associated with a specific question. The correct answer is ensured to be 
        included, and the wrong answers are selected randomly to provide variation.

        Args:
            question (str): The text of the question for which answers are fetched.

        Returns:
            list: A list of four answers as strings, shuffled in random order. The 
                list always includes one correct answer and three wrong answers.

        SQL Query Details:
            - The first part fetches one correct answer using the condition 
            `right_answer = TRUE`.
            - The second part fetches three wrong answers using the condition 
            `right_answer = FALSE`, and orders them randomly.
            - The `UNION ALL` combines these results into a single result set.
            - The use of `ORDER BY RANDOM()` ensures the wrong answers are randomized.
            - `LIMIT` is used to restrict the number of answers fetched for each condition.
        """
        query = """
        (
            SELECT answer FROM answers 
            JOIN questions ON answers.question_id = questions.question_id 
            WHERE question_text = %s AND right_answer = TRUE
            LIMIT 1
        )
        UNION ALL
        (
            SELECT answer FROM answers 
            JOIN questions ON answers.question_id = questions.question_id 
            WHERE question_text = %s AND right_answer = FALSE
            ORDER BY RANDOM()
            LIMIT 3
        );
        """
        return self.fetch_data(query, (question, question))
               
    def check_user_answer(self, user_answer):
        query = "SELECT right_answer FROM answers WHERE answer=%s;"
        return self.fetch_data(query,(user_answer, ))

    def get_question_explanation(self, question_text):
        query = """SELECT explanation FROM questions WHERE question_text=%s"""
        return self.fetch_data(query,(question_text, ))
        

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
    
    def get_name_actual_user(self, user_id):
        """
        Retrieves the name of the user associated with the given user ID.

        Args:
            user_id (int): The unique identifier of the user.

        Returns:
            str: The name of the user if found, otherwise None.
        
        Example:
            user_name = get_name_actual_user(5)
            print(user_name)  # Output: "John Doe"
        """
        query = """
            SELECT name
            FROM users
            WHERE user_id=%s;"""
        return self.fetch_data(query, (user_id,))
    
    def log_user(self, username, password):
        """
        Authenticate a user by verifying their username and password.

        This function checks the `user_log` table to validate the provided 
        username and password. The password is hashed using the same salt
        as the stored `hashed_password` using the `crypt()` function 
        for secure comparison.

        Parameters:
            username (str): The username provided by the user during login.
            password (str): The plain-text password provided by the user during login.

        Returns:
            tuple: The result of the query, typically containing the user_id 
                if the username and password are correct. Returns an empty 
                result if authentication fails.
        """
        query = """
        SELECT user_id 
        FROM user_log
        WHERE username=%s AND hashed_password = crypt(%s, hashed_password);
        """
        return self.fetch_data(query, (username, password))

    def track_user_progress(self, username):
        query = """
        SELECT total_score, last_score, total_matchs
        FROM users
        JOIN user_log ON users.user_id = user_log.user_id
        WHERE user_log.username = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (username,))
                return cursor.fetchall()[0]

        except Exception as e:
            self.conn.rollback()  # Rollback any failed transaction
            logging.error(f"Database query failed for username {username}: {e}")
            return []

    def add_score_to_user(self, score, user):
        query = """
            UPDATE users
            SET total_score = total_score + %s,
                last_score = %s,
                total_matchs = total_matchs + %s
            WHERE name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (score, score, 1,  user))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to update score status for {user}: {e}")
            return 0  # Indicate failure)
    
    def set_logged_status(self, name, is_logged_in):
        """Updates the logged status of a user."""
        query = """
            UPDATE users
            SET logged = %s
            WHERE name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (is_logged_in, name))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to update logged status for {name}: {e}")
            return 0  # Indicate failure)
        
    def add_user(self, user_data: dict):
        """
        Insert a new user into the database.

        This function adds a new user to the `users` table and logs their 
        authentication details in the `user_log` table. It uses transactions 
        to ensure that either both operations succeed or both are rolled back 
        in case of failure, maintaining data consistency.

        Parameters:
            user_data (dict): A dictionary containing user details:
                - name (str): The name of the user to be added.
                - username (str): The username for authentication.
                - hashed_password (str): The hashed password for secure storage.

        Returns:
            int: The number of rows affected in the database (should be 1 for successful insertion).
                Returns 0 if the insertion fails due to a duplicate username or another error.

        Exceptions:
            psycopg2.errors.UniqueViolation: Raised if the username already exists in the database.
            Exception: Any other error encountered during database operations.

        Notes:
            - The `user_log` table requires the `pgcrypto` extension for hashing passwords using `crypt()`.
            - Rolls back the transaction if any error occurs.
        """
        user_query = """
            INSERT INTO users (name) 
            VALUES (%s)
            RETURNING user_id;
        """
        user_log_query = """
            INSERT INTO user_log (user_id, username, hashed_password) 
            VALUES (%s, %s, crypt(%s, gen_salt('bf')));
        """
        try:
            with self.conn.cursor() as cursor:
                #insert data into users
                cursor.execute(user_query, (user_data["name"],))
                user_id = cursor.fetchone()[0] # Retrieve generated user_id

                # insert data into user_log
                cursor.execute(user_log_query, (user_id, user_data["username"], user_data["hashed_password"]))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except psycopg2.errors.UniqueViolation:
            self.conn.rollback()
            print(f"Error: Username '{user_data["username"]}' already exists. Please choose a different one.")
            return 0  # Indicate failure)
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to add new user: {e}")
            return 0  # Indicate failure)
    
    ### admin functions ###

    def get_category_id(self, category, category_name):
        """
        Retrieves the category ID for the specified category name.

        Args:
            category (str): The category type (module or submodule).
            category_name (str): The name of the category to retrieve.

        Returns:
            int: The category ID if found, otherwise None.
        """
        query = f"""
        SELECT {category}_id 
        FROM {category}s
        WHERE {category}_name=%s;
        """
        result = self.fetch_data(query, (category_name,))

        #check result is a single integer
        if result:
            return result[0] #extract the first value of a list
        return None

    def add_new_topic(self, topic, description=None):
        """
        Adds a new topic to the topics database table.

        Args:
            topic (str): The name of the new topic.
            description (str): A brief description of the topic.

        Returns:
            int: The number of affected rows (1 if successful, 0 if failed).
        """
        query = """
            INSERT INTO topics (topic_name, topic_description)
            VALUES (%s, %s);      
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (topic, description))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to insert data into topics: {e}")
            return 0  # Indicate failure)
        
    def add_new_category(self, parent_id, parent_name, category, category_name, description=None):
        """
        Inserts a new category entry into the specified database table.

        Args:
            parent_id (int): The unique identifier of the parent category (e.g., topic ID for modules).
            parent_name (str): The name of the parent entity (e.g., 'topic' for modules).
            category (str): The database table name where the category should be inserted (e.g., 'topic' or 'module').
            category_name (str): The name of the new category to be added.
            description (str, optional): A brief description of the new category. Defaults to None.

        Returns:
            int: The number of affected rows (1 if the insertion is successful, 0 if it fails).
        """
        query = f"""
            INSERT INTO {category}s ({parent_name}_id, {category}_name, {category}_description)
            VALUES (%s, %s, %s);      
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (parent_id, category_name, description))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to insert data into {category}s: {e}")
            return 0  # Indicate failure)
    
    def remove_user(self, username):
        query = f"""
            DELETE FROM users
            WHERE user_id IN (
                SELECT users.user_id
                FROM users 
                JOIN user_log ON users.user_id = user_log.user_id
                WHERE user_log.username = %s
            );
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (username,))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to remove user {username}: {e}")
            return -1  # Indicate failure)
        
    def remove_submodule(self, submodule_name):
        query = f"""
            DELETE FROM submodules
            WHERE submodule_name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (submodule_name,))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to remove submodule {submodule_name}: {e}")
            return -1  # Indicate failure)
    
    def remove_module(self, module_name):
        query = f"""
            DELETE FROM modules
            WHERE module_name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (module_name,))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to remove module {module_name}: {e}")
            return -1  # Indicate failure)
    
    def remove_topic(self, topic_name):
        query = f"""
            DELETE FROM topics
            WHERE topic_name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (topic_name,))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to remove topic {topic_name}: {e}")
            return -1  # Indicate failure)