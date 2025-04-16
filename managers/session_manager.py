from core.menu import Menu
import random
from managers.style_manager import Styler
import logging
class SessionManager():
    def __init__(self, quiz, question_manager, admin_manager, db_manager, input_handler): 
        self.quiz = quiz
        self.question_manager= question_manager
        self.admin_manager = admin_manager
        self.db_manager = db_manager
        self.input_handler = input_handler

    def admin_session(self, current_user):
        """
        Handles the admin session workflow, enabling data management operations.

        Provides the admin with options to perform data-related tasks, such as 
        inserting, removing, or updating records. Continuously loops through 
        available operations until the admin selects the logout option or 
        returns to the main menu.

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
        """
        Facilitates the admin's ability to update various types of data.

        Presents a menu of update options, enabling the admin to perform tasks such as:
        - Updating questions.
        - Modifying categories (topics, modules, submodules).
        - Updating user details.

        Continuously loops through the menu until the admin chooses to go back or log out.
        Based on the admin's selection, the corresponding update method is invoked.

        Args:
            current_user (str): The username of the currently logged-in admin.
            wanted_operation (str): The operation type indicating the task 
                                    the admin intends to perform ('update').

        Returns:
            str: Returns 'back' to navigate to the previous menu or 
                 'logout' to terminate the admin session.
        """
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'from')
            if choice == "1": 
                self.question_manager.update_question()
            elif choice == "2":
                print("Update topic")
                self.admin_manager.update_category('topic')
            elif choice == "3":
                print("Update module")
                self.admin_manager.update_category('module')
            elif choice == "4":
                print("Update submodule") 
                self.admin_manager.update_category('submodule')
            elif choice == "5":
                    print("You are not allowed to change data from user")
                    return 'back'
            elif choice == "6":
                return 'back'
            elif choice == "7":
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))

    def admin_insert_data(self, current_user, wanted_operation):
        """
        Executes update operations within the admin workflow.

        Provides the admin with a menu of update options, allowing them to 
        modify questions, topics, modules, submodules, or user data. Based 
        on the admin's selection, the corresponding update method is invoked. 
        The loop continues until the admin chooses to go back or logout.

        Args:
            current_user (str): The username of the currently logged-in admin.
            wanted_operation (str): The operation type indicating the task 
                                    the admin intends to perform.

        Returns:
            str: Returns 'back' to navigate to the previous menu or 
                 'logout' to terminate the admin session.
        """
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'to')
            if choice == "1":
                #add new question in the db
                self.question_manager.add_question()

            elif choice == "2":
                print("Create new topic:")
                new_topic_added = self.admin_manager.create_new_topic()
                # succesfully returns 1(True), else 0 (False)
                if new_topic_added:
                    print(Styler.confirmation_message("Topic created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new topic"))
            elif choice == "3":
                print("Create new module:")
                new_module_added = self.admin_manager.create_new_module()
                # succesfully returns 1(True), else 0 (False)
                if new_module_added:
                    print(Styler.confirmation_message("Module created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new module"))
                
            elif choice == "4":
                print("Create new submodule:")
                new_submodule_added = self.admin_manager.create_new_submodule()
                if new_submodule_added:
                    print(Styler.confirmation_message("Submodule created and added to the db"))
                else:
                    print(Styler.error_message("Error creating a new submodule"))
            elif choice == "5":
                self.admin_manager.admin_insert_user()
            elif choice == "6":
                return 'back'
            elif choice == "7":
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))
    
    def admin_remove_data(self, current_user, wanted_operation):
        """
        Facilitates the removal of various types of data by the admin.

        Provides a menu that allows the admin to delete specific records, such as 
        questions, topics, modules, submodules, and users. The appropriate removal 
        method is executed based on the admin's choice. The loop continues until 
        the admin decides to go back or log out.

        Args:
            current_user (str): Username of the currently logged-in admin.
            wanted_operation (str): Indicates the type of operation ('remove').

        Returns:
            str: Returns 'back' if the admin chooses to return to the previous menu,
                 'logout' if the admin decides to end the session, or None if the 
                 loop completes without a specific return statement.
        """
        while True:
            choice = Menu.display_admin_menu(wanted_operation.capitalize(), 'from')
            if choice == 1:
                self.question_manager.remove_question()
            elif choice == "2":
                print("Delete topic:")
                self.admin_manager.remove_topic()
            elif choice == "3":
                print("Delete module")
                self.admin_manager.remove_module()
            elif choice == "4":
                print("Delete submodule") 
                self.admin_manager.remove_submodule() 
            elif choice == "5":
                print("Remove user")
                self.admin_manager.remove_user()
            elif choice == "6":
                return 'back'
            elif choice == "7":
                print("Loging out")
                #set the logged status from actual user as False in the db.
                self.db_manager.set_logged_status(current_user, False)
                return 'logout'
            else:
                print(Styler.warning_message("Invalid choice. Please try again."))
        
         
    def player_session(self,current_user, user_id, username):
        """
        Manages the player's session, enabling participation in quizzes and progress tracking.

        Provides the player with options to:
        1. Take a quiz by selecting a game mode (by category or difficulty).
        2. View their progress, including total score, last score, and total matches played.
        3. Log out of the session.

        Continuously loops through the menu until the player opts to log out.

        Args:
            current_user (str): The identifier of the currently logged-in player.
            username (str): The unique username of the player (used for tracking progress).
        """
        # Display the main player menu and prompt the user for a choice
        try:
            while True:
                choice = Menu.display_user_menu()

                if choice == "1":
                    while True:
                        # Display the game mode menu and prompt the user for a selection
                        game_mode = Menu.display_game_modus_menu()

                        if game_mode == "1":

                            # user submodul choice for the play
                            user_choice = self.question_manager.take_category_for_questions()

                            # Fetch quiz questions from the database based on the chosen category and mode 'topics'
                            questions = self.db_manager.fetch_questions(user_choice)
                            break
                        elif game_mode == "2":

                            # Fetch quiz questions from the database based on game mode 'difficulty'
                            difficulty = self.input_handler.get_difficulty()
                            questions = self.db_manager.fetch_questions_difficulty_mode(difficulty)
                            break
                        else:
                            # Handle invalid input for game mode selection
                            print(Styler.warning_message("Invalid choice. Please try again."))

                    # Shuffle the fetched questions for randomization
                    random.shuffle(questions)
                    if len(questions) > 0:

                        # Start the quiz with the fetched questions
                        self.quiz.start(questions, current_user)
                    else:
                        # Handle the case where no questions are available for the chosen criteria
                        print(Styler.warning_message("The category choosed doesn't have questions, going back to menu"))

                elif choice == "2":
                    print("\t📊 User Progress Report 📊")
                    print("=" * 40)

                    # Fetch user progress data from the database
                    user_data = self.db_manager.track_user_progress(username)  

                    # Extract values
                    total_score, last_score, total_matchs = user_data

                    # Extract individual progress metrics
                    print(f"🎯 Total Score:   {total_score}")
                    print(f"📈 Last Score:    {last_score}")
                    print(f"🏆 Total Matches: {total_matchs}")
                    print("=" * 40)

                elif choice == "3":  # Option to change user data
                    print("Update user")
                    result = self.admin_manager.update_user(user_id, current_user)
                    if result == -1:
                        # Handle UniqueViolation error (username exists)
                        continue
                    elif result == 0:
                        print(Styler.error_message("❌ An error occurred while updating the user."))
                        continue
                    elif result == 1:
                        print(Styler.confirmation_message("User updated successfully."))
                        self.db_manager.set_logged_status(current_user, False)
                        break
                    else:
                        break
                elif choice == "4": # Option to log out
                    print(Styler.confirmation_message("Loging out"))
                    # Update the logged-in status of the current user in the database
                    self.db_manager.set_logged_status(current_user, False)
                    break
                else:
                    # Handle invalid input for the main player menu
                    print(Styler.warning_message("Invalid choice. Please try again."))
        except Exception as e:
            # print(Styler.error_message("You are logged out!"))
            # logging.error(f"Unexpected error: {e}")
            self.db_manager.set_logged_status(current_user, False)