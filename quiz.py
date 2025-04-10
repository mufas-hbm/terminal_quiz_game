import random
from menu import Menu
from data_input import InputHandler
from question_manager import QuestionManager
import time

class Quiz:
    def __init__(self, db_manager,input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler

    def start(self, questions, username):
        score = 0
        question_counter = 1
        
        #define max questions for each play
        max_questions = 5

        # Loop through each question retrieved
        for question in questions[:max_questions]:
            print(f"Question number {question_counter}:")
            question_counter += 1
            print(question)

            # Fetch possible answers associated with the question in random order
            answers = self.db_manager.fetch_answers_from_question(question)
            random.shuffle(answers)

            # Display the available answer choices with their respective indexes
            for index, answer_text in enumerate(answers, start=1):
                print(f'{index}: {answer_text}')

            # Prompt the user to input their answer choice (numeric index). 
            try:
                user_answer = int(self.input_handler.quiz_get_user_answer())
                # if user_answer is None:
                #     print("\nTime's up! Moving to the next question")
                #     continue
            
                if 1 <= user_answer <= len(answers):
                    # Extract the user's selected answer
                    user_answer = answers[user_answer-1].strip()
                else:
                    continue
                
                #extract column 'right_answer' (bool) from db
                # Validate the user's answer against the correct answer stored in the database
                check_answer = self.db_manager.check_user_answer(user_answer)[0]
                if check_answer is True:
                    print("\nCorrect! +1 Point\n")
                    score += 1
                else:
                    print("\n False!\n")

                    #shows answer explanation to user
                    question_explanation = self.db_manager.get_question_explanation(question)[0] 
                    print(f"\t**{question_explanation}**\n")

            # Handle invalid inputs and moving on
            except (ValueError, TypeError, IndexError):
                print("Invalid input! Moving to the next question.")

        # shows final score and add the data into the db
        print(f"\nYour final score: {score}/{max_questions}")
        self.db_manager.add_score_to_user(score, username)
        print("\nYour total score and matches were updated")
              


    
    # def prepare_questions(self):
    #     try:
    #         play_general_questions = False

    #         # Fetch topic
    #         topic_id = int(self.input_handler.get_input("topic"))
    #         topic_db = self.db_manager.get_choice("topic", topic_id)
    #         print(topic_db)
    #         if not topic_db:
    #             play_general_questions = True
    #         else:
    #             # Fetch module filtered by topic_id
    #             module_id = int(self.input_handler.get_input("module"))
    #             module_db = self.db_manager.get_choice("module", module_id, parent_id=topic_id)
    #             print(module_db)
    #             if not module_db:
    #                 play_general_questions = True
    #             else:
    #                 # Fetch submodule filtered by module_id
    #                 submodule_id = int(self.input_handler.get_input("submodule"))
    #                 submodule_db = self.db_manager.get_choice("submodule", submodule_id, parent_id=module_id)
    #                 print(submodule_db)
    #                 if submodule_db:
    #                     return submodule_id
    #                 else:
    #                     play_general_questions = True

    #         if play_general_questions:
    #             print("You will play with general questions.")
    #             return None
    #     except Exception as e:
    #         print("Error during preparation:", e)
    #         return None
                

    # def prepare_questions(self):
        # topic = self.input_handler.get_topic().lower().capitalize().strip()
        # topics_db = self.db_manager.fetch_topics()
        # play_general_questions = False
        # prepare_questions = ""
        # if topic in topics_db:
        #     module = self.input_handler.get_module().lower().capitalize().strip()
        #     modules_db = self.db_manager.fetch_modules(topic)
        #     if module in modules_db:
        #         #.lower().capitalize().strip() doesn't work for a 2 words string
        #         submodule = self.input_handler.get_submodule().lower().capitalize().strip()
        #         submodules_db = self.db_manager.fetch_submodules_from_module(module)
        #         if submodule in submodules_db:
        #             prepare_questions = submodule       
        #         else:
        #             print("The subtopic you entered doesn't exists, you will play with general questions")
        #             play_general_questions = True
        #     else:
        #         print("The topic you entered doesn't exists, you will play with general questions")
        #         play_general_questions = True
        # else:
        #     print("The topic you entered doesn't exists, you will play with general questions")
        #     play_general_questions = True
        #print(prepare_questions)
        #if play_general_questions:

    # def prepare_questions(self):
    #     try:
    #         play_general_questions = False

            
    #         topic = self.input_handler.get_topic().strip().capitalize()
    #         topics_db = self.db_manager.fetch_topics()

    #         if topic not in topics_db:
    #             play_general_questions = True
    #         else:
    #             module = self.input_handler.get_module()
    #             modules_db = self.db_manager.fetch_modules(topic)

    #             if module not in modules_db:
    #                 play_general_questions = True
    #             else:
    #                 submodule = self.input_handler.get_submodule().strip()
    #                 submodules_db = self.db_manager.fetch_submodules_from_module(module)

    #                 if submodule in submodules_db:
    #                     print(f" You selected {submodule}, let's play")
    #                     return submodule
    #                 else:
    #                     play_general_questions = True

    #         if play_general_questions:
    #             print("You will play with general questions.")
    #             return None
    #     except Exception as e:
    #         print("Error during preparation:", e)
    #         return None

    # def take_category_for_questions(self):
    #     try:
    #         play_general_questions = False

    #         topic = int(self.input_handler.get_topic())

    #         if topic not in self.db_dict:
    #             play_general_questions = True
    #         else:
    #             module = int(self.input_handler.get_module())

    #             if module not in self.db_dict[topic]['modules']:
    #                 play_general_questions = True
    #             else:
    #                 submodule = int(self.input_handler.get_submodule())

    #                 for sub in self.db_dict[topic]['modules'][module]['submodules']:
    #                     if sub['index'] == submodule:
    #                         print(f" You selected {sub['name']}, let's play")
    #                         return sub['name']  # Return the submodule name

    #                 play_general_questions = True

    #         if play_general_questions:
    #             print("You will play with general questions.")
    #             return None
    #     except Exception as e:
    #         print("Error during preparation:", e)
    #         return None