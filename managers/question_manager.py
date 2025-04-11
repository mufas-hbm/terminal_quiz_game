from managers.style_manager import Styler

class QuestionManager:
    def __init__(self, db_manager, input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler

    def add_question(self):
        """
        Adds a new question to the database.

        The question is associated with a submodule, difficulty level, explanation, hint, and answers.
        If the selected submodule doesn't exist, the question is added to general questions.
        Both correct and incorrect answers are stored in the database.

        Raises:
            Exception: Logs an error message if adding the question fails.
        """
        # Retrieve the submodule where the question belongs
        submodule_name = self.input_handler.get_submodule()
        db_submodules = self.db_manager.fetch_submodules_add_questions()

        # If submodule doesn't exist, assign the question to general questions
        if submodule_name not in db_submodules:
            print(Styler.warning_message("This submodule doesn't exists, your question will be added to general questions"))
            submodule_name = None

        # Gather question details from user input
        difficulty = self.input_handler.get_difficulty()
        question_text = self.input_handler.get_question_text()
        explanation = self.input_handler.get_explanation()
        hint = self.input_handler.get_hint()
        correct_answer = self.input_handler.get_correct_answer()
        wrong_answers:list = self.input_handler.get_wrong_answers()

        try:
            with self.db_manager.conn.cursor() as cursor: # Automatically closes the cursor after execution
                
                # Insert the question into the database
                insert_questions_query = """
                    INSERT INTO questions 
                    (submodule_id, question_text, difficulty, explanation, hint)
                    VALUES ((SELECT submodule_id FROM submodules WHERE submodule_name=%s), %s, %s, %s, %s) RETURNING question_id;
                """
                cursor.execute(insert_questions_query, (submodule_name, question_text, difficulty, explanation, hint))
                
                # Retrieve the newly added question ID
                question_id = cursor.fetchone()[0]
                
                # Insert answers associated with the question
                insert_answers_query = """
                    INSERT INTO answers 
                    (question_id, answer, right_answer)
                    VALUES ((SELECT question_id FROM questions WHERE question_id=%s), %s, %s) RETURNING question_id;
                """

                #insert correct answer
                cursor.execute(insert_answers_query, (question_id, correct_answer, True))

                #insert all wrong answers
                for question in wrong_answers:
                    cursor.execute(insert_answers_query, (question_id, question, False))

                # Commit changes to the database
                self.db_manager.conn.commit()
                print(Styler.confirmation_message("Question added successfully!"))

        except Exception as e:
            print(Styler.error_message("Error adding question:", e))

    def remove_question(self):
        question_to_delete = self.input_handler.get_question_text()
        question_deleted = self.db_manager.remove_question(question_to_delete)
        if question_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Question {question_to_delete} deleted successfully! 🎉"))
        elif question_deleted == 0:
            print(Styler.warning_message(f"⚠️ Question '{question_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting question {question_to_delete}. Please check the logs."))

    def take_category_for_questions(self):
        """
        Guides the user through selecting a topic, module, and submodule dynamically.
        """
        try:
            # Step 1: Fetch Topics
            topics = self.db_manager.get_data("topics")
            if not topics:
                print(Styler.warning_message("No topics available."))
                return None
            
            print("\nTopics to choose:")
            for idx, name in enumerate(topics, start=1):
                print(f"{idx}: {name}", end=" | ")
            print("\n")

            topic_idx = int(self.input_handler.get_topic()) - 1
            if topic_idx not in range(len(topics)):
                print(Styler.warning_message("Invalid topic selection. Defaulting to general questions."))
                return None

            topic = topics[topic_idx]

            # Step 2: Fetch Modules for Selected Topic
            modules = self.db_manager.get_data("modules", topic)
            if not modules:
                print(Styler.warning_message(f"No modules available for '{topic}', proceeding with general questions."))
                return None

            print("\nModules to choose:")
            for idx, name in enumerate(modules, start=1):
                print(f"{idx}: {name}", end=" | ")
            print("\n")

            module_idx = int(self.input_handler.get_module()) - 1
            if module_idx not in range(len(modules)):
                print(Styler.warning_message("Invalid module selection. Proceeding with general questions."))
                return None

            module = modules[module_idx]

            # Step 3: Fetch Submodules for Selected Module
            submodules = self.db_manager.get_data("submodules", module)
            if not submodules:
                print(Styler.warning_message(f"No submodules available for '{module}', proceeding with general questions."))
                return None

            print("\nSubmodules to choose:")
            for idx, name in enumerate(submodules, start=1):
                print(f"{idx}: {name}", end=" | ")
            print("\n")

            submodule_idx = int(self.input_handler.get_submodule()) - 1
            if submodule_idx not in range(len(submodules)):
                print(Styler.warning_message("Invalid submodule selection. Proceeding with general questions."))
                return None

            submodule = submodules[submodule_idx]
            print(Styler.confirmation_message(f"\nYou selected '{submodule}', let's play!"))
            return submodule

        except Exception as e:
            print(Styler.error_message(f"Error during category selection: {e}"))
            return None


"""
quiz_app=# SELECT questions.submodule_id, questions.question_text, answers.right_answer
quiz_app-# FROM questions
quiz_app-# INNER JOIN answers ON questions.question_id=answers.question_id
quiz_app-# INNER JOIN submodules ON questions.submodule_id=submodules.submodule_id
quiz_app-# WHERE submodule_name='Loops';
"""