from managers.style_manager import Styler

class AdminManager():
    """
    A manager class for handling administrative tasks.

    The `AdminManager` class provides methods to facilitate the management of topics, 
    modules, submodules, and users within a database. It includes features for creating, 
    deleting, and registering data entries, making it ideal for administrative operations 
    in a structured database system.

    Attributes:
        db_manager: An instance of the database manager used to interact with the database.
        input_handler: An optional instance of the input handler used to gather user input.

    Methods:
        ### ADD FUNCTIONS ###
        create_new_topic():
            Creates a new topic in the database by prompting the user for input.
        create_new_module():
            Adds a new module under an existing topic.
        create_new_submodule():
            Adds a new submodule under an existing module.
        admin_insert_user():
            Registers a new user in the database with the admin's input.
        
        ### DELETE FUNCTIONS ###
        remove_topic():
            Removes a specified topic from the database.
        remove_module():
            Deletes a specified module from the database.
        remove_submodule():
            Deletes a specified submodule from the database.
         remove_user():
            Deletes a specified user from the database.

        ### MODIFY FUNCTIONS ###
        update_user():
            Updates the details of an existing user in the database, including their 
            username, name, and password. Provides appropriate feedback messages 
            depending on the success or failure of the operation.
        update_category(category):
            Updates the details of an existing category (topic, module, or submodule) 
            in the database. Ensures that the old category name exists before performing 
            the update and provides feedback messages for different outcomes.
    """

    def __init__(self, db_manager, input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler
    
    ### ADD FUNCTIONS ###

    def create_new_topic(self):
        """
        Creates a new topic in the database.

        This method facilitates the addition of a new topic by:
        - Prompting the user to input the name and description of the new topic.
        - Passing the collected data to the database manager's `add_new_topic` method 
          for storage in the database.

        Args:
            None

        Returns:
            int: 1 if the insertion is successful, 0 if it fails.

        Notes:
            - Relies on `input_handler` to gather the topic name and description.
            - The `add_new_topic` method in the database manager handles the database insertion.
        """
 
        new_topic_name = self.input_handler.get_topic()
        new_topic_description = self.input_handler.get_description()
        new_topic_added = self.db_manager.add_new_topic(new_topic_name, new_topic_description)
        return new_topic_added
    
    def create_new_module(self):
        """
        Facilitates the creation of a new module in the database.

        The method performs the following:
        - Prompts the user to enter the name of an existing topic.
        - Fetches the topic ID from the database using the provided topic name.
        - If the topic exists, gathers the name and description for the new module.
        - Passes the data (topic ID, module name, and description) to the database manager's 
          `add_new_category` method to add the module to the database.
        - If the topic does not exist, displays a warning message indicating the inability 
          to add the module.

        Returns:
            int: 1 if the insertion is successful, 0 if it fails

        Notes:
            - Relies on `input_handler` for gathering user input.
            - The `add_new_category` method is used for adding the module to the database.
            - Displays a warning message if the specified module name is not found in the database.
        """
        # Get topic name from the user
        topic_name = self.input_handler.get_topic()
        # Get the topic ID from the database as int
        topic_id = self.db_manager.get_category_id("topic", topic_name)
        if topic_id is not None:
            new_module_name = self.input_handler.get_module()
            new_module_description = self.input_handler.get_description()
            new_module_added = self.db_manager.add_new_category(topic_id, "topic", "module", new_module_name, new_module_description)
            return new_module_added
        else:
            print(Styler.warning_message("The topic you entered doesn't exist, so the module can't be added."))
        
    def create_new_submodule(self):
        """
        Facilitates the creation of a new submodule in the database.

        The method performs the following:
        - Prompts the user to enter the name of an existing module.
        - Fetches the module ID from the database using the provided module name.
        - If the module exists, gathers the name and description for the new submodule.
        - Passes the data (module ID, submodule name, and description) to the database manager's 
          `add_new_category` method to add the submodule to the database.
        - If the module does not exist, displays a warning message indicating the inability 
          to add the submodule.

        Returns:
            int: 1 if the insertion is successful, 0 if it fails

        Notes:
            - Relies on `input_handler` for gathering user input.
            - The `add_new_category` method is used for adding the submodule to the database.
            - Displays a warning message if the specified module name is not found in the database.
        """

        # Get module name from the user
        module_name = self.input_handler.get_module()
    
        # Get the module ID from the database as int
        module_id = self.db_manager.get_category_id("module", module_name)
        if module_id is not None:
            new_submodule_name = self.input_handler.get_submodule()
            new_submodule_description = self.input_handler.get_description()

            #args(parent_id, parent table, actual table, category_name, category_description)
            new_submodule_added = self.db_manager.add_new_category(module_id, "module", "submodule", new_submodule_name, new_submodule_description)
            return new_submodule_added
        else:
            print(Styler.warning_message("The module you entered doesn't exist, so the submodule can't be added."))

    def admin_insert_user(self):
        """
        Handles the creation of a new user by the admin.

        This method allows an admin to register a new user by:
        - Gathering user data via the `input_handler.register` method.
        - Passing the collected data to the database manager's `add_user` method for storage.
        - Displaying a confirmation message upon successful user creation.
        - Displaying an error message if the user creation fails.

        Notes:
            - The `user_data` dictionary contains relevant information required for user registration.
            - The `add_user` method in the database manager returns a boolean indicating success or failure.
        """
        user_data = self.input_handler.register()
        new_user = self.db_manager.add_user(user_data)
        if new_user:
            print(Styler.confirmation_message(f"🎉 New user {user_data['name']} created successfully! 🎉"))
        else:
            print(Styler.error_message("Error creating new user"))

    ### DELETE FUNCTIONS ###

    def remove_topic(self):
        """
        Handles the removal of a specified topic from the database.

        Prompts the user to input the name of the topic to delete. Passes the provided 
        topic name to the database manager's `remove_topic` method to perform the 
        deletion operation. Based on the result of the deletion, displays appropriate 
        messages indicating success, failure due to a non-existent topic, or an error 
        during the operation.

        Notes:
            - The method relies on `input_handler.get_topic` to gather user input.
            - Displays a confirmation message upon successful deletion.
            - Warns the user if the topic does not exist.
            - Logs and notifies the user in case of unexpected errors.
        """

        topic_to_delete = self.input_handler.get_topic()
        topic_deleted = self.db_manager.remove_topic(topic_to_delete)
        if topic_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Topic {topic_to_delete} deleted successfully! 🎉"))
        elif topic_deleted == 0:
            print(Styler.warning_message(f"⚠️ Topic '{topic_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting topic {topic_to_delete}. Please check the logs."))

    def remove_module(self):
        """
        Manages the removal of a specified module from the database.

        Prompts the user to input the name of the module to delete. Passes the provided 
        name to the database manager's `remove_module` method to execute the deletion. 
        Based on the return value, displays appropriate messages indicating success, 
        failure due to a non-existent module, or an error during execution.

        Notes:
            - User input is validated and passed to the database manager for processing.
            - Messages include:
                - Confirmation of successful deletion.
                - Warnings for non-existent submodules.
                - Error notifications for unexpected issues.
        """
        module_to_delete = self.input_handler.get_module()
        module_deleted = self.db_manager.remove_module(module_to_delete)
        if module_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Module {module_to_delete} deleted successfully! 🎉"))
        elif module_deleted == 0:
            print(Styler.warning_message(f"⚠️ Submodule '{module_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting module {module_to_delete}. Please check the logs."))
        
    def remove_submodule(self):
        """
        Manages the removal of a specified submodule from the database.

        Prompts the user to input the name of the submodule to delete. Passes the provided 
        name to the database manager's `remove_submodule` method to execute the deletion. 
        Based on the return value, displays appropriate messages indicating success, 
        failure due to a non-existent submodule, or an error during execution.

        Notes:
            - User input is validated and passed to the database manager for processing.
            - Messages include:
                - Confirmation of successful deletion.
                - Warnings for non-existent submodules.
                - Error notifications for unexpected issues.
        """
        submodule_to_delete = self.input_handler.get_submodule()
        submodule_deleted = self.db_manager.remove_submodule(submodule_to_delete)
        if submodule_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Submodule {submodule_to_delete} deleted successfully! 🎉"))
        elif submodule_deleted == 0:
            print(Styler.warning_message(f"⚠️ Submodule '{submodule_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting submodule {submodule_to_delete}. Please check the logs."))

    def remove_user(self):
        username_to_delete = self.input_handler.get_username()
        #return number of affected rows after the query in db executes
        user_removed = self.db_manager.remove_user(username_to_delete)
        if user_removed == 1:
            print(Styler.confirmation_message(f"🎉 User {username_to_delete} deleted successfully! 🎉"))
        elif user_removed == 0:
            print(Styler.warning_message(f"⚠️ User '{username_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting user {username_to_delete}. Please check the logs."))
    
    ### MODIFY FUNCTIONS ###
    
    def update_user(self, user_id, current_user):
        """
        Updates a specific attribute of a user based on their choice.

        This method prompts the user to choose which attribute to update (name, username, or password).
        It then fetches the new value for the chosen attribute and updates the database accordingly.

        Args:
            user_id (int): The ID of the user to be updated.
            current_user (str): The current username of the user.

        Returns:
            None
        """
        options = ["name", "username", "password"]
        choice = input("What do you want to update (name, username, password):")

        if choice == options[0]:
            arg_to_update = "name"
            value_to_update = self.input_handler.get_name()
        elif choice == options[1]:
            arg_to_update = "username"
            value_to_update = self.input_handler.get_username()
        elif choice == options[2]:
            arg_to_update = "hashed_password"
            value_to_update = self.input_handler.get_password()
        else:
            # Handle invalid input
            print(Styler.warning_message("Invalid choice. Please try again."))
            return
        updated_user = self.db_manager.update_user(user_id, current_user, arg_to_update, value_to_update)
        if updated_user == 1:
            print(Styler.confirmation_message(f"🎉 User {current_user} updated successfully! you are logged to out keep data in the system🎉"))
        else:
            print(Styler.error_message(f"❌ Error updating user {current_user}. Please check the logs.\n You are logged out to keep consistency"))

            

    
    
    def update_category(self, category):
        if category == 'topic':
            old_category_name = self.input_handler.get_topic()
            existing_topics = self.db_manager.fetch_category(category)
            if old_category_name in existing_topics:
                new_category_name = self.input_handler.get_topic()
                new_description = self.input_handler.get_description()
                updated_category = self.db_manager.update_category(category, old_category_name, new_category_name, new_description)
                if updated_category == 1:
                    print(Styler.confirmation_message(f"🎉 {category} {old_category_name} updated successfully! 🎉"))
                elif updated_category == 0:
                    print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))
                else:
                    print(Styler.error_message(f"❌ Error updating {category}{old_category_name}. Please check the logs."))
            else:
                print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))
        elif category == 'module':
            old_category_name = self.input_handler.get_module()
            existing_modules = self.db_manager.fetch_category(category)
            if old_category_name in existing_modules:
                new_category_name = self.input_handler.get_module()
                new_description = self.input_handler.get_description()
                updated_category = self.db_manager.update_category(category, old_category_name, new_category_name, new_description)
                if updated_category == 1:
                    print(Styler.confirmation_message(f"🎉 {category} {old_category_name} updated successfully! 🎉"))
                elif updated_category == 0:
                    print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))
                else:
                    print(Styler.error_message(f"❌ Error updating {category}{old_category_name}. Please check the logs."))
            else:
                print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))
        elif category == 'submodule':
            old_category_name = self.input_handler.get_submodule()
            existing_submodules = self.db_manager.fetch_category(category)
            if old_category_name in existing_submodules:
                new_category_name = self.input_handler.get_submodule()
                new_description = self.input_handler.get_description()
                updated_category = self.db_manager.update_category(category, old_category_name, new_category_name, new_description)
                if updated_category == 1:
                    print(Styler.confirmation_message(f"🎉 {category} {old_category_name} updated successfully! 🎉"))
                elif updated_category == 0:
                    print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))
                else:
                    print(Styler.error_message(f"❌ Error updating {category}{old_category_name}. Please check the logs."))
            else:
                print(Styler.warning_message(f"⚠️ {category} '{old_category_name}' not found."))