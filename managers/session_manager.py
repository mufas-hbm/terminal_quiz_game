from core.menu import Menu
import random
from managers.style_manager import Styler
class SessionManager():
    def __init__(self, quiz, question_manager, admin_manager, db_manager, input_handler): 
        self.quiz = quiz
        self.question_manager= question_manager
        self.admin_manager = admin_manager
        self.db_manager = db_manager
        self.input_handler = input_handler

    def admin_session(self, current_user):
        """
        Manages the admin's session, allowing them to insert or remove data.

        Presents the admin with options to insert or remove data and calls
        the corresponding methods based on their choice. The loop continues
        until the admin chooses to go back to the main menu.

        Args:
            current_user (str): The username of the currently logged-in admin.
        """
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
            elif wanted_operation == 'update':
                action = self.admin_update_data(current_user, wanted_operation)
                if action == 'logout':
                    break
            else:
                break

    def admin_update_data(self,current_user,wanted_operation):
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'from')
            if choice == 1:
                self.question_manager.update_question()
            elif choice == 2:
                print("Update topic:")
                self.admin_manager.update_topic()
            elif choice == 3:
                print("Update module")
                self.admin_manager.update_module()
            elif choice == 4:
                print("Update submodule") 
                self.admin_manager.update_submodule() 
            elif choice == 5:
                print("Update user")
            elif choice == 6:
                return 'back'
            elif choice == 7:
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))

    def admin_insert_data(self, current_user, wanted_operation):
        """
        Allows the admin to insert various types of data into the database.

        Presents a menu of options for inserting questions, topics, modules,
        submodules, and users. Calls the appropriate methods to handle each
        insertion type based on the admin's choice.

        Args:
            current_user (str): The name of the currently logged-in admin.
            wanted_operation (str): The operation chosen by the admin ('insert').

        Returns:
            str or None: Returns 'back' if the admin chooses to go back to the
                        admin session menu, 'logout' if the admin chooses to log out,
                        and None otherwise (if the inner loop completes without
                        explicitly returning).
        """
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'to')
            if choice == 1:
                #add new question in the db
                self.question_manager.add_question()

            elif choice == 2:
                print("Create new topic:")
                new_topic_added = self.admin_manager.create_new_topic()
                # succesfully returns 1(True), else 0 (False)
                if new_topic_added:
                    print(Styler.confirmation_message("Topic created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new topic"))
            elif choice == 3:
                print("Create new module:")
                new_module_added = self.admin_manager.create_new_module()
                # succesfully returns 1(True), else 0 (False)
                if new_module_added:
                    print(Styler.confirmation_message("Module created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new module"))
                
            elif choice == 4:
                print("Create new submodule:")
                new_submodule_added = self.admin_manager.create_new_submodule()
                if new_submodule_added:
                    print(Styler.confirmation_message("Submodule created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new submodule"))
            elif choice == 5:
                self.admin_manager.admin_insert_user()
            elif choice == 6:
                return 'back'
            elif choice == 7:
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))
    
    def admin_remove_data(self, current_user, wanted_operation):
        """
        Allows the admin to remove various types of data from the database.

        Presents a menu of options for removing questions, topics, modules,
        submodules, and users. Calls the appropriate methods to handle each
        removal type based on the admin's choice.

        Args:
            current_user (str): The name of the currently logged-in admin.
            wanted_operation (str): The operation chosen by the admin ('remove').

        Returns:
            str or None: Returns 'back' if the admin chooses to go back to the
                        admin session menu, 'logout' if the admin chooses to log out,
                        and None otherwise (if the inner loop completes without
                        explicitly returning).
        """
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'from')
            if choice == 1:
                #add new question in the db
                self.question_manager.remove_question()

            elif choice == 2:
                print("Delete topic:")
                self.admin_manager.remove_topic()
            elif choice == 3:
                print("Delete module")
                self.admin_manager.remove_module()
            elif choice == 4:
                print("Delete submodule") 
                self.admin_manager.remove_submodule() 
            elif choice == 5:
                print("Remove user")
                self.admin_manager.remove_user()
            elif choice == 6:
                return 'back'
            elif choice == 7:
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))
        
         
    def player_session(self,current_user, username):
        """
        Manages the player's session, allowing them to take quizzes and track progress.

        Presents the player with options to start a quiz, track their progress,
        and log out. Calls the appropriate methods based on their choice.
        The loop continues until the player chooses to log out.

        Args:
            current_user (str): The name of the currently logged-in player.
            username (str): The username of the currently logged-in player (UNIQUE).
        """
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
                        print(Styler.warning_message("Invalid choice. Please try again."))


                random.shuffle(questions)
                #questions = questions[:max(5, len(questions))]
                if len(questions) > 0:
                    #run the quiz
                    self.quiz.start(questions, current_user)
                else:
                    print(Styler.warning_message("The category choosed doesn't have questions, going back to menu"))

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
                print(Styler.confirmation_message("Loging out"))

                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                break
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))