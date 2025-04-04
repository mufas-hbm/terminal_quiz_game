from database_manager import DatabaseManager
from menu import Menu
from question_manager import QuestionManager
from data_input import InputHandler
from quiz import Quiz
from config import db_config


def main():
    db_manager = DatabaseManager(**db_config)
    db_manager.connect()

    input_handler = InputHandler()
    quiz = Quiz(db_manager, input_handler)
    question_manager = QuestionManager(db_manager, input_handler)

    print("---WELCOME THE THE QUIZ GAME---\n")
    while True:
        choice = Menu.display_main_menu()
        if choice == '1':
            username = input_handler.get_username()
            password = input_handler.get_password()
            try:
                user_id = db_manager.log_user(username, password)[0]
                name = db_manager.get_name_actual_user(user_id)[0].strip()
                print(f"Welcome {name}")
                print(type(name))

                #set the logged status from actual as True in the db.
                db_manager.set_logged_status('hector', True)
                while True:
                    choice = Menu.display_user_menu()

                    if choice == '1':
                        #Menu.display_topics_menu(db_manager)
                        # user submodul choice for the play
                        user_choice = question_manager.take_category_for_questions()
                        
                        quiz.start(user_choice)
                        
                        #print(quiz.prepare_questions())
                    elif choice == '2':
                        question_manager.add_question()
                    elif choice == '3':
                        print("Loging out")
                        #set the logged status from actual user as False in the db.
                        db_manager.set_logged_status(name, False)
                        break
                    else:
                        print("Invalid choice. Please try again.")
            except Exception as e:
                print("username or password wrong, try again or register")
        elif choice == '2':
            print("Register")
        elif choice == '3':
            print("Exiting the application. Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

    db_manager.close()

if __name__ == "__main__":
    main()
