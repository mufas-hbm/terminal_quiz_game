class Menu:
    @staticmethod
    def display_user_menu():
        print("\nMain Menu:")
        print("1. Take a Quiz")
        print("2. Add a New Question(will be removed after admin implementation)")
        print("3. Log Out")
        choice = input("Enter your choice (1-3): ")
        return choice
    
    @staticmethod
    def display_main_menu():
        print("Log Menu:")
        print("1. Log in")
        print("2. Register")
        print("3. Exit")
        choice = input("Enter your choice (1-3): ")
        return choice
    
    @staticmethod
    def display_admin_menu():
        print("Admin Menu:")
        print("1. Add new question")
        print("2. Add topic to database")
        print("3. Add modul to database")
        print("4. Add submodul to database")
        print("5. Log out")
        choice = input("Enter your choice (1-5): ")
        return choice
    

"""
database_dict = {
    1: {
    'name': 'Programming', 
    'modules': {
        1: {
            'name': 'Python Basics', 
            'submodules': [
                {
                    'name': 'Variables', 
                    'index': 1
                }, 
                {
                    'name': 'Loops', 
                    'index': 2
                }]
            }, 
        2: {
            'name': 'Data Structures', 
            'submodules': [
                {
                    'name': 'Linked Lists', 
                    'index': 1
                }, 
                {
                    'name': 'Trees', 
                    'index': 2
                }]
            }}}, 
    2: {'name': 'Mathematics', 'modules': {1: {'name': 'Algebra', 'submodules': [{'name': 'Linear Equations', 'index': 1}]}, 2: {'name': 'Calculus', 'submodules': [{'name': 'Derivatives', 'index': 1}]}}}, 3: {'name': 'History', 'modules': {1: {'name': 'World War II', 'submodules': [{'name': 'Battle of Britain', 'index': 1}]}, 2: {'name': 'Ancient Egypt', 'submodules': [{'name': 'Pharaohs', 'index': 1}]}}}}
"""

# def display_topics_menu(db_manager):
    #     try:
    #         topics = db_manager.fetch_topics()
    #         if not topics:
    #             print("No topics found.")
    #             return
            
    #         for topic_index, topic in enumerate(topics, start=1):
    #             print(f"Topic {topic_index}: {topic}")
    #             modules = db_manager.fetch_modules(topic)
                
    #             if modules:
    #                 print(f"  Modules for {topic}:")
    #                 for module_index, module in enumerate(modules, start=1):
    #                     print(f"    {module_index}. {module}")
                        
    #                     # Fetch submodules for the current module
    #                     submodules = db_manager.fetch_submodules_from_module(module)
    #                     if submodules:
    #                         print(f"      Submodules for {module}:")
    #                         for submodule_index, submodule in enumerate(submodules, start=1):
    #                             print(f"        {submodule_index}. {submodule}")
    #                     else:
    #                         print(f"      No submodules found for module {module}.")
    #             else:
    #                 print(f"  No modules found for topic {topic}.")

    #     except Exception as e:
    #         print(f"Error displaying topics menu: {e}")

    # def display_modules_menu(db_manager):
    #     modules = db_manager.fetch_modules()
    #     for i, module in enumerate(modules, start=1):
    #         print (f"   {i} {module}")

    # def display_submodules_menu(db_manager):
    #     submodules = db_manager.fetch_submodules()
    #     for i, submodule in enumerate(submodules, start=1):
    #         print (f"   {i} {submodule}")
    
    
