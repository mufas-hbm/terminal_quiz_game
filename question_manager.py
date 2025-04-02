from data_input import InputHandler
from database_manager import DatabaseManager
from config import db_config

class QuestionManager:
    def __init__(self, db_manager, input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler
        self.db_dict = self.db_manager.create_database_dict()

    def add_question(self):
        submodule_name = self.input_handler.get_submodule()
        db_submodules = self.db_manager.fetch_submodules_add_questions()
        """ print(self.db_manager.fetch_modules())
        print(self.db_manager.fetch_topics())"""
        if submodule_name not in db_submodules:
            print("This submodule doesn't exists, your question will be added to general questions")
            submodule_name = None
        difficulty = self.input_handler.get_difficulty()
        question_text = self.input_handler.get_question_text()
        explanation = self.input_handler.get_explanation()
        hint = self.input_handler.get_hint()
        correct_answer = self.input_handler.get_correct_answer()
        wrong_answers:list = self.input_handler.get_wrong_answers()

        try:
            with self.db_manager.conn.cursor() as cursor: # to close the cursor after the queries
                insert_questions_query = """
                    INSERT INTO questions 
                    (submodule_id, question_text, difficulty, explanation, hint)
                    VALUES ((SELECT submodule_id FROM submodules WHERE submodule_name=%s), %s, %s, %s, %s) RETURNING question_id;
                """
                cursor.execute(insert_questions_query, (submodule_name, question_text, difficulty, explanation, hint))
                #get the question id previously added
                question_id = cursor.fetchone()[0]
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
                
                self.db_manager.conn.commit()
                print("Question added successfully!")
        except Exception as e:
            print("Error adding question:", e)


    def take_category_for_questions(self):
        try:
            play_general_questions = False
            try:
                #extract the topics with his index and put it on a list
                topic_info_list = [(topic_index, topic_data['name']) for topic_index, topic_data in self.db_dict.items()]

                #Show available topics
                print("Topics to choose:")
                for index, name in topic_info_list:
                    print(f"{index}: {name}", end=' | ')
                print(f'\n')
            except Exception as e:
                print("Error extracting the topics from dictionary", e)

            topic = int(self.input_handler.get_topic())

            if topic not in self.db_dict:
                play_general_questions = True
            else:
                try:
                    #extract the modules with his index and put it on a list
                    module_info_list = [(module_index, module_data['name']) for module_index, module_data in self.db_dict[topic]['modules'].items()]

                    #Show available modules
                    print("Modules to choose:")
                    for index, name in module_info_list:
                        print(f"{index}: {name}", end=' | ')
                    print()
                except Exception as e:
                    print("Error extracting the modules from dictionary", e)

                module = int(self.input_handler.get_module())

                if module not in self.db_dict[topic]['modules']:
                    play_general_questions = True
                else:
                    try:
                        # Extract the submodules with their index and put them in a list
                        submodule_info_list = [(submodule_data['index'], submodule_data['name']) for submodule_data in self.db_dict[topic]['modules'][module]['submodules']]

                        # Show available submodules
                        print("Submodules to choose:")
                        for index, name in submodule_info_list:
                            print(f"{index}: {name}", end=' | ')
                        print()

                    except Exception as e:
                        print("Error extracting the submodules from dictionary:", e)

                    submodule = int(self.input_handler.get_submodule())

                    for sub in self.db_dict[topic]['modules'][module]['submodules']:
                        if sub['index'] == submodule:
                            print(f" You selected {sub['name']}, let's play")
                            return sub['name']  # Return the submodule name

                    play_general_questions = True

            if play_general_questions:
                print("You will play with general questions.")
                return None
        except Exception as e:
            print("Error during preparation:", e)
            return None

"""
quiz_app=# SELECT questions.submodule_id, questions.question_text, answers.right_answer
quiz_app-# FROM questions
quiz_app-# INNER JOIN answers ON questions.question_id=answers.question_id
quiz_app-# INNER JOIN submodules ON questions.submodule_id=submodules.submodule_id
quiz_app-# WHERE submodule_name='Loops';
"""
"""input_handler = InputHandler()
db_manager = DatabaseManager(**db_config)
db_manager.connect()
#print("Database connection:", db_manager.conn)
question_manager = QuestionManager(db_manager, input_handler)
question_manager.add_question()
db_manager.close()"""