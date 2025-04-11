
from managers.style_manager import Styler

class Admin():
    def __init__(self, db_manager, input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler
    
    ### ADD FUNCTIONS ###

    def create_new_topic(self):  
        new_topic_name = self.input_handler.get_topic()
        new_topic_description = self.input_handler.get_description()
        new_topic_added = self.db_manager.add_new_topic(new_topic_name, new_topic_description)
        return new_topic_added
    
    def create_new_module(self):
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
        user_data = self.input_handler.register()
        new_user = self.db_manager.add_user(user_data)
        if new_user:
            print(Styler.confirmation_message(f"🎉 New user {user_data['name']} created successfully! 🎉"))
        else:
            print(Styler.error_message("Error creating new user"))

    ### DELETE FUNCTIONS ###

    def remove_topic(self):
        topic_to_delete = self.input_handler.get_topic()
        topic_deleted = self.db_manager.remove_topic(topic_to_delete)
        if topic_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Topic {topic_to_delete} deleted successfully! 🎉"))
        elif topic_deleted == 0:
            print(Styler.warning_message(f"⚠️ Topic '{topic_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting topic {topic_to_delete}. Please check the logs."))

    def remove_module(self):
        module_to_delete = self.input_handler.get_module()
        module_deleted = self.db_manager.remove_module(module_to_delete)
        if module_deleted == 1:
            print(Styler.confirmation_message(f"🎉 Module {module_to_delete} deleted successfully! 🎉"))
        elif module_deleted == 0:
            print(Styler.warning_message(f"⚠️ Submodule '{module_to_delete}' not found."))
        else:
            print(Styler.error_message(f"❌ Error deleting module {module_to_delete}. Please check the logs."))
        
    def remove_submodule(self):
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
    def update_topic(self):

    def update_description(self):
        category = self.input_handler.modify_description()
        new_description = self.input_handler.get_description()
        updated_description = self.db_manager.update_description(category, new_description)
        if updated_description == 1:
            print(Styler.confirmation_message(f"🎉 Description for {category} updated successfully! 🎉"))
        elif updated_description == 0:
            print(Styler.warning_message(f"⚠️ '{category}' not found."))
        else:
            print(Styler.error_message(f"❌ Error updating description for {category}. Please check the logs."))
    
    #def update_question(self)