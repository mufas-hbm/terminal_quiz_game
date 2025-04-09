from menu import Menu
class SessionManager():
    def __init__(self, quiz, question_manager, admin_manager, db_manager, input_handler): 
        self.quiz = quiz
        self.question_manager= question_manager
        self.admin_manager = admin_manager
        self.db_manager = db_manager
        self.input_handler = input_handler

    def admin_session(self, current_user):
        while True:
            wanted_operation = self.input_handler.get_modification_type()
            if wanted_operation == 'insert':
                action = self.admin_insert_data(current_user,wanted_operation)
                if action == 'logout':
                    break
            elif wanted_operation == 'remove':
                action = self.admin_remove_data(current_user, wanted_operation)
                if action == 'logout':
                    break
            else:
                break

    def admin_insert_data(self, current_user, wanted_operation):
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'to')
            if choice == '1':
                #add new question in the db
                self.question_manager.add_question()

            elif choice == '2':
                print("Create new topic:")
                new_topic_added = self.admin_manager.create_new_topic()
                # succesfully returns 1(True), else 0 (False)
                if new_topic_added:
                    print("\nTopic created and added to the db\n")
                else:
                    print("Error creating a new topic")
            elif choice == '3':
                print("Create new module:")
                new_module_added = self.admin_manager.create_new_category()
                # succesfully returns 1(True), else 0 (False)
                if new_module_added:
                    print("\nModule created and added to the db\n")
                else:
                    print("Error creating a new module")
                
            elif choice == '4':
                print("Create new submodule:")
                new_submodule_added = self.admin_manager.create_new_submodule()
                if new_submodule_added:
                    print("\nSubmodule created and added to the db\n")
                else:
                    print("Error creating a new submodule")
            elif choice == '5':
                user_data = self.input_handler.register()
                new_user = self.db_manager.add_user(user_data)
                if new_user:
                    print(f"\n🎉 New user {user_data['name']} created successfully! 🎉")
                else:
                    print("Error creating new user")
            elif choice == '6':
                return 'back'
            elif choice == '7':
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print("Invalid choice. Please try again.")
    
    def admin_remove_data(self, current_user, wanted_operation):
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'from')
            if choice == '1':
                #add new question in the db
                self.question_manager.add_question()

            elif choice == '2':
                print("Delete topic:")
                topic_to_delete = self.input_handler.get_topic()
                topic_deleted = self.db_manager.remove_topic(topic_to_delete)
                if topic_deleted == 1:
                    print(f"\n🎉 Topic {topic_to_delete} deleted successfully! 🎉")
                elif module_deleted == 0:
                    print(f"⚠️ Topic '{topic_to_delete}' not found.")
                else:
                    print(f"❌ Error deleting topic {topic_to_delete}. Please check the logs.")
            elif choice == '3':
                print("Delete module:")
                module_to_delete = self.input_handler.get_module()
                module_deleted = self.db_manager.remove_module(module_to_delete)
                if module_deleted == 1:
                    print(f"\n🎉 Module {module_to_delete} deleted successfully! 🎉")
                elif module_deleted == 0:
                    print(f"⚠️ Submodule '{module_to_delete}' not found.")
                else:
                    print(f"❌ Error deleting module {module_to_delete}. Please check the logs.")
                
            elif choice == '4':
                print("Delete submodule:")
                submodule_to_delete = self.input_handler.get_submodule()
                submodule_deleted = self.db_manager.remove_submodule(submodule_to_delete)
                if submodule_deleted == 1:
                    print(f"\n🎉 Submodule {submodule_to_delete} deleted successfully! 🎉")
                elif submodule_deleted == 0:
                    print(f"⚠️ Submodule '{submodule_to_delete}' not found.")
                else:
                    print(f"❌ Error deleting submodule {submodule_to_delete}. Please check the logs.")    
            elif choice == '5':
                print("Remove user:")
                username_to_delete = self.input_handler.get_username()
                #return number of affected rows after the query in db executes
                user_removed = self.db_manager.remove_user(username_to_delete)
                if user_removed == 1:
                    print(f"\n🎉 User {username_to_delete} deleted successfully! 🎉")
                elif user_removed == 0:
                    print(f"⚠️ User '{username_to_delete}' not found.")
                else:
                    print(f"❌ Error deleting user {username_to_delete}. Please check the logs.")
            elif choice == '6':
                return 'back'
            elif choice == '7':
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print("Invalid choice. Please try again.")
        
         
    def player_session(self,current_user, username):
        while True:
            choice:int = Menu.display_user_menu()

            if choice == 1:
                while True:
                    # #choose game mode
                    game_mode = Menu.display_game_modus_menu()

                    if game_mode == 1:

                        # user submodul choice for the play
                        user_choice = self.question_manager.take_category_for_questions()

                        # Fetch quiz questions from the database based on the chosen category and mode 'topics'
                        questions = self.db_manager.fetch_questions(user_choice)
                        break
                    elif game_mode == 2:

                        # Fetch quiz questions from the database based on game mode 'difficulty'
                        difficulty = self.input_handler.get_difficulty()
                        questions = self.db_manager.fetch_questions_difficulty_mode(difficulty)
                        break
                    else:
                        print("Invalid choice. Please try again.")

                #run the quiz
                self.quiz.start(questions, current_user)

            elif choice == 2:
                print("\t📊 User Progress Report 📊")
                print("=" * 40)

                user_data = self.db_manager.track_user_progress(username)  

                # Extract values
                total_score, last_score, total_matchs = user_data

                # Print results
                print(f"🎯 Total Score:   {total_score}")
                print(f"📈 Last Score:    {last_score}")
                print(f"🏆 Total Matches: {total_matchs}")
                print("=" * 40)

            elif choice == 3:
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                break
            else:
                print("Invalid choice. Please try again.")