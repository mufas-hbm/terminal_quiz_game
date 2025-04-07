from database_manager import DatabaseManager
from menu import Menu
from data_input import InputHandler
from quiz import Quiz
from question_manager import QuestionManager
from admin import Admin
from config import db_config
from session_manager import SessionManager


def main():
    db_manager = DatabaseManager(**db_config)
    db_manager.connect()

    # Instantiate class objects
    input_handler = InputHandler()
    quiz = Quiz(db_manager, input_handler)
    question_manager = QuestionManager(db_manager, input_handler)
    admin_manager = Admin(db_manager, input_handler)
    session_manager = SessionManager(quiz,question_manager, admin_manager, db_manager)

    print("---WELCOME THE THE QUIZ GAME---\n")
    while True:
        choice = Menu.display_main_menu()
        if choice == '1':
            try:
                username = input_handler.get_username()
                password = input_handler.get_password()
                user_id = db_manager.log_user(username, password)[0]
                name = db_manager.get_name_actual_user(user_id)[0].strip()
                print(user_id, name)
            
                print(f"Welcome {name}")

                #set the logged status from actual as True in the db.
                db_manager.set_logged_status(name, True)

                if name == "admin":
                    session_manager.admin_session(name)
                else:
                    session_manager.player_session(name)
            except Exception as e:
                print("username or password wrong, try again or register")
                ####
                # if name != 'admin':
                #     while True:
                #         choice = Menu.display_user_menu()

                #         if choice == '1':
                            
                #             # user submodul choice for the play
                #             user_choice = question_manager.take_category_for_questions()
                            
                #             #run the quiz
                #             quiz.start(user_choice)
                                                      
                #         elif choice == '2':
                #             print("Loging out")
                #             #set the logged status from actual user as False in the db.
                #             db_manager.set_logged_status(name, False)
                #             break
                #         else:
                #             print("Invalid choice. Please try again.")
                # else:
                #     while True:
                #         choice = Menu.display_admin_menu()
                #         if choice == '1':
                #             #add new question in the db
                #             question_manager.add_question()

                #         elif choice == '2':
                #             print("Create new topic:")
                #             new_topic_added = admin_manager.create_new_topic()
                #             # succesfully returns 1(True), else 0 (False)
                #             if new_topic_added:
                #                 print("\nTopic created and added to the db\n")
                #             else:
                #                 print("Error creating a new topic:")
                #         elif choice == '3':
                #             print("Create new module:")
                #             new_module_added = admin_manager.create_new_category()
                #             # succesfully returns 1(True), else 0 (False)
                #             if new_module_added:
                #                 print("\nModule created and added to the db\n")
                #             else:
                #                 print("Error creating a new module:")
                            
                #         elif choice == '4':
                #             print("Create new submodule:")
                #             new_submodule_added = admin_manager.create_new_submodule()
                #             if new_submodule_added:
                #                 print("\nSubmodule created and added to the db\n")
                #             else:
                #                 print("Error creating a new submodule:")
                            
                #         elif choice == '5':
                #             print("Loging out")
                #             #set the logged status from actual user as False in the db.
                #             db_manager.set_logged_status(name, False)
                #             break
                #         else:
                #             print("Invalid choice. Please try again.")
        elif choice == '2':
            print("\n New user register\n")
            user_data = input_handler.register()
            new_user = db_manager.add_user(user_data)
            if new_user:
                print(f"New user {user_data["name"]} was created")
            else:
                print("Error creating new user")
        elif choice == '3':
            print("Exiting the application. Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

    db_manager.close()

if __name__ == "__main__":
    main()
