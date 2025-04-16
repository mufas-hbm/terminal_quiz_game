import psycopg2
import logging
from managers.style_manager import Styler

# Configure logging to write errors to a file
logging.basicConfig(
    filename='logs/error.log',
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
            print(Styler.error_message("Error connecting to the database:", e))

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
            print(Styler.error_message("Error closing the database:", e))
    
    def fetch_submodules_add_questions(self):
        """
        Retrieves the names of all submodules from the database used to add questions.

        Executes a query to fetch the `submodule_name` column from the `submodules` table 
        and returns the result.

        Args:
            None

        Returns:
            list: A list containing the names of all submodules. 
                  The format of the result depends on the implementation of the `fetch_data` method.
        """
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
    
    def fetch_category(self, category):
        """Fetch names from a category_table"""
        query = f"""
            SELECT {category}_name 
            FROM {category}s;
        """
        return self.fetch_data(query, (category,))

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
        """
        Retrieves the progress statistics of a specified user from the database.

        Executes a query to fetch the total score, last score, and total matches 
        played by the user identified by their username. The information is obtained 
        by joining the `users` and `user_log` tables on the user ID.

        If the query fails, rolls back the transaction to maintain data integrity 
        and logs the error for debugging purposes.

        Args:
            username (str): The username of the user whose progress statistics 
                            are to be retrieved.

        Returns:
            list: A list containing the user's progress data in the format:
                  [total_score, last_score, total_matches].
                  Returns an empty list if an error occurs or no data is found.

        Notes:
            - Ensure the `username` corresponds to a valid entry in the `user_log` table.
            - Handles database errors gracefully by rolling back the transaction 
              and logging the exception.
        """

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
        """
        Updates the user's score and match statistics in the database.

        This method performs the following:
        - Increments the user's total score by the provided `score`.
        - Updates the user's last score with the provided `score`.
        - Increments the total matches played by the user by 1.
        - Commits the changes to the database if the operation is successful.

        In the event of an error:
        - Rolls back the transaction to preserve data integrity.
        - Logs the error for debugging purposes.

        Args:
            score (int): The score to be added to the user's total and set as the last score.
            user (str): The name of the user whose score and match statistics will be updated.

        Returns:
            int: The number of rows affected by the update operation.
                 Returns 0 if an error occurs during execution.

        Notes:
            - Ensure that the `user` argument matches an existing entry in the database.
            - The `cursor.rowcount` indicates the number of rows successfully updated.
        """

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
        """
        Updates the logged-in status of a specified user.

        Executes a query to update the `logged` column in the `users` table 
        for the user identified by their name. Commits the changes to the 
        database if the operation is successful. In case of an error, 
        rolls back the transaction to maintain data integrity and logs 
        the error for debugging purposes.

        Args:
            name (str): The name of the user whose logged status is being updated.
            is_logged_in (bool): The new logged-in status to be applied to the user (True or False).

        Returns:
            int: The number of rows affected by the update operation.
                 Returns 0 if an error occurs during execution.

        Notes:
            - Ensure that the `name` argument matches an existing user in the database.
            - Handles errors gracefully by rolling back changes and logging the exception.
        """
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
            print(Styler.error_message(f"Error: Username '{user_data["username"]}' already exists. Please choose a different one."))
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
        """
        Deletes a user and their associated data from the database.

        Executes a query to delete the user identified by their username. The deletion 
        is performed on the `users` table, joined with the `user_log` table to ensure 
        the correct user is targeted based on their username.

        If the operation is successful, commits the transaction to save the changes. 
        In case of an error, rolls back the transaction to maintain data integrity and 
        logs the error for debugging purposes.

        Args:
            username (str): The username of the user to be deleted.

        Returns:
            int: The number of rows affected by the delete operation. 
                 Returns -1 if an error occurs during execution.

        Notes:
            - The `username` must correspond to an existing entry in the `user_log` table.
            - Handles errors gracefully by reverting changes and logging the exception.
        """

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
        """
        Deletes a specified submodule from the database.

        Executes a query to remove the submodule identified by its name from the `submodules` table.
        If the deletion is successful, commits the changes to the database. In case of an error, 
        rolls back the transaction to preserve data integrity and logs the error for troubleshooting.

        Args:
            submodule_name (str): The name of the submodule to be deleted.

        Returns:
            int: The number of rows affected by the delete operation. 
                 Returns -1 if an error occurs during execution.

        Notes:
            - Ensure that the `submodule_name` matches the exact entry in the database.
            - Handles errors gracefully by rolling back changes and logging the exception.
        """
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
        """
        Removes a specified module from the database.

        Executes a query to delete the module identified by its name from the `modules` table.
        If the operation succeeds, the changes are committed to the database. In case of 
        an error, the transaction is rolled back to preserve data integrity, and the 
        error is logged for debugging purposes.

        Args:
            module_name (str): The name of the module to be deleted.

        Returns:
            int: The number of rows affected by the delete operation. 
                 Returns -1 if an error occurs during the execution.

        Notes:
            - Ensure that the `module_name` matches exactly with the corresponding entry in the database.
            - Error handling includes rollback to prevent partial updates.
        """
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
        """
        Removes a specified topic from the database.

        Executes a query to delete the topic identified by its name from the `topics` table.
        If the operation succeeds, the changes are committed to the database. In case of 
        an error, the transaction is rolled back to preserve data integrity, and the 
        error is logged for debugging purposes.

        Args:
            topic_name (str): The name of the topic to be deleted.

        Returns:
            int: The number of rows affected by the delete operation. 
                 Returns -1 if an error occurs during the execution.

        Notes:
            - Ensure that the `topic_name` matches exactly with the corresponding entry in the database.
            - Error handling includes rollback to prevent partial updates.
        """
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
        
    def remove_question(self, question):
        """
        Removes a specified question from the database.

        Executes a query to delete the question identified by its text from the `questions` table.
        If the operation is successful, commits the changes to the database. Handles errors by 
        rolling back the transaction to maintain data integrity and logs the error for debugging.

        Args:
            question (str): The text of the question to be deleted.

        Returns:
            int: The number of rows affected by the delete operation. 
                 Returns -1 if an error occurs during execution.

        Notes:
            - Ensure the `question` argument matches the exact text in the database.
            - Logs errors for troubleshooting purposes if the deletion fails.
        """
        query = f"""
            DELETE FROM questions
            WHERE question_text = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (question,))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to remove question {question}: {e}")
            return -1  # Indicate failure)
    
    def update_question(self, old_question_text,submodule_id, new_question_text, difficulty, explanation, hint):
        """
        Updates an existing question in the database with new details.

        The method performs the following:
        - Updates the question text, associated submodule ID, difficulty level, 
          explanation, and hint for a specific question identified by its 
          current text (`old_question_text`).
        - Commits the changes to the database if the update is successful.

        In the event of an error:
        - Rolls back the transaction to maintain data integrity.
        - Logs the error for debugging purposes.

        Args:
            old_question_text (str): The current text of the question to be updated.
            submodule_id (int): The ID of the submodule associated with the question.
            new_question_text (str): The updated text for the question.
            difficulty (str): The difficulty level of the question (e.g., 'easy', 'medium', 'hard').
            explanation (str): The updated explanation for the question.
            hint (str): The updated hint for the question.

        Returns:
            int: The number of rows affected by the update operation. Returns -1 if an error occurs.

        Notes:
            - Ensure that the `submodule_id` corresponds to a valid submodule in the database.
            - The `cursor.rowcount` indicates the number of rows successfully updated.
        """

        query = f"""
            UPDATE questions
            SET question_text = %s, submodule_id = %s, difficulty = %s, explanation = %s, hint = %s
            WHERE question_text = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, (new_question_text, submodule_id, difficulty, explanation, hint, old_question_text))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to update question: {e}")
            return -1  # Indicate failure)
    
    def fetch_question(self, question_text):
        """
        Fetches the ID of a specified submodule from the database.

        Executes a query to retrieve the `submodule_id` for the given `submodule_name` 
        from the `submodules` table.

        Args:
            submodule_name (str): The name of the submodule whose ID is to be retrieved.

        Returns:
            tuple: The result of the query containing the submodule ID, or None if no match is found.
        """
        query = """SELECT question_text from questions where question_text=%s"""
        return self.fetch_data(query, (question_text,))
    
    def fetch_submodule_id(self, submodule_name):
        query = """SELECT submodule_id from submodules where submodule_name=%s"""
        return self.fetch_data(query, (submodule_name,))
    
    def fetch_user(self,username):
        """
        Retrieves the user ID for a given username.

        Executes a database query to fetch the user ID from the `users` table, 
        joining it with the `user_log` table based on matching user IDs.

        Args:
            username (str): The username of the user whose ID is to be fetched.

        Returns:
            tuple: The result of the query containing the user ID, or None if no match is found.
        """
        query = """SELECT users.user_id from users JOIN user_log ON users.user_id=user_log.user_id where username=%s"""
        return self.fetch_data(query, (username,))

    def update_user(self, user_id, current_user, arg_to_update, value_to_update):
        """
        Updates a specific attribute of a user in the database.

        Dynamically constructs the appropriate SQL query based on the `arg_to_update` value. 
        Handles updates for `name`, `username`, and `password`, committing the changes to 
        the database if successful. Rolls back the transaction and logs errors in case of failure.

        Args:
            user_id (int): The unique ID of the user to be updated.
            current_user (str): The current username of the user.
            arg_to_update (str): The name attribute being updated.
            value_to_update (str): The new value of the chosed atribute being updated.

        Returns:
            int: The number of rows affected by the update operation. 
                 Returns 0 in case of errors or if the operation fails.

        Notes:
            - Handles `name` updates in the `users` table.
            - Handles `username` and `password` updates in the `user_log` table.
            - Validates inputs and ensures rollback on errors.
        """
        # Define variables for dynamic query construction
        query = None
        query_args = None
        
        # Determine which query to execute based on the attribute to update
        if arg_to_update == "name":
            query = """
                UPDATE users 
                SET name=%s
                WHERE user_id=%s;
            """
            query_args = (value_to_update, user_id)
        elif arg_to_update == "username":
            query = """
                UPDATE user_log
                SET username=%s 
                WHERE username=%s;
            """
            query_args = (value_to_update, current_user)
        elif arg_to_update == "hashed_password":
            query = """
                UPDATE user_log
                SET hashed_password=crypt(%s, gen_salt('bf'))  
                WHERE user_id=%s;
            """
            query_args = (value_to_update, user_id)
        try:
            with self.conn.cursor() as cursor:
                # Execute the dynamic query with arguments
                cursor.execute(query, query_args)
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except psycopg2.errors.UniqueViolation as e:
            self.conn.rollback()
            print(Styler.error_message(f"Username '{value_to_update}' already exists."))
            logging.error(f"Failed to update user {current_user}: {e}")
            return -1  # Return a specific error code for this case
        except Exception as e:
            # Revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to update user {current_user}: {e}")
            return 0  # Indicate failure
        

    def update_category(self, category, old_category_name, new_category_name, new_description):
        """
        Updates the name and description of a specified category in the database.

        The method performs the following:
        - Updates the name of the given category (e.g., 'topic', 'module', 'submodule') 
          by replacing `old_category_name` with `new_category_name`.
        - Updates the description of the category with `new_description`.
        - Commits changes to the database upon successful execution.

        Handles errors by rolling back the transaction and logging the error message 
        to ensure data integrity.

        Args:
            category (str): The category type to be updated (e.g., 'topic', 'module', 'submodule').
            old_category_name (str): The current name of the category to be updated.
            new_category_name (str): The new name for the category.
            new_description (str): The new description to be applied to the category.

        Returns:
            int: The number of rows affected by the update operation, or -1 if the update fails.
        """

        query1 = f"""
            UPDATE {category}s
            SET {category}_name = %s
            WHERE {category}_name = %s;
        """
        query2 = f"""
            UPDATE {category}s
            SET {category}_description = %s
            WHERE {category}_name = %s;
        """
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query1, (new_category_name, old_category_name))
                cursor.execute(query2, (new_description, new_category_name))
                self.conn.commit()  # Ensure the update is saved
                return cursor.rowcount  # Return number of affected rows
        except Exception as e:
            #revert changes made during the current transaction if this didn't execute well
            self.conn.rollback()
            logging.error(f"Failed to update name or decscription from {category}: {e}")
            return -1  # Indicate failure)