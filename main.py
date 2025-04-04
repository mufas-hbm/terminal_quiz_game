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

                #set the logged status from actual as True in the db.
                db_manager.set_logged_status(name, True)
                if name != 'admin':
                    while True:
                        choice = Menu.display_user_menu()

                        if choice == '1':
                            
                            # user submodul choice for the play
                            user_choice = question_manager.take_category_for_questions()
                            
                            #run the quiz
                            quiz.start(user_choice)
                                                      
                        elif choice == '2':
                            print("Loging out")
                            #set the logged status from actual user as False in the db.
                            db_manager.set_logged_status(name, False)
                            break
                        else:
                            print("Invalid choice. Please try again.")
                else:
                    while True:
                        choice = Menu.display_admin_menu()
                        if choice == '1':

                            question_manager.add_question()

                        elif choice == '2':
                            print("Create new topic:")
                            new_topic_name = input_handler.get_topic()
                            new_topic_description = input_handler.get_description()
                            db_manager.add_new_topic(new_topic_name, new_topic_description)
                            print("\nTopic created and added to the db\n")
                        elif choice == '3':
                            print("Create new module:")

                            # Get topic name from the user
                            topic_name = input_handler.get_topic()
                            

                            try:
                                # Get the topic ID from the database as int
                                topic_id = db_manager.get_category_id("topic", topic_name)
                                if topic_id is not None:
                                    print(type(topic_id))
                                    new_module_name = input_handler.get_module()
                                    new_module_description = input_handler.get_description()
                                    db_manager.add_new_category(topic_id, "topic", "module", new_module_name, new_module_description)
                                    print("Module created and added to the database.\n")
                                else:
                                    print("The topic you entered doesn't exist, so the module can't be added.")
     
                            except Exception as e:
                                print("Problem trying to add insert new module")
    
                        elif choice == '4':
                            print("Create new submodule:")

                            # Get mocule name from the user
                            module_name = input_handler.get_module()
                            
                            try:
                                # Get the module ID from the database as int
                                module_id = db_manager.get_category_id("module", module_name)
                                if module_id is not None:
                                    new_submodule_name = input_handler.get_submodule()
                                    new_submodule_description = input_handler.get_description()

                                    #args(parent_id, parent table, actual table, category_name, category_description)
                                    db_manager.add_new_category(module_id, "module", "submodule", new_submodule_name, new_submodule_description)
                                    print("Submodule created and added to the database.\n")
                                else:
                                    print("The module you entered doesn't exist, so the submodule can't be added.")
                            except Exception as e:
                                print("problem trying to add new submodule")
                        elif choice == '5':
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
