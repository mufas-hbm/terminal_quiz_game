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
            choice = Menu.display_admin_menu()
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
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                break
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