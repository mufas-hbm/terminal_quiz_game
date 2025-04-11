from managers.style_manager import Styler

class Menu:
    @staticmethod
    def display_user_menu():
        options = ["Take a Quiz", "Track my progress", "Log Out"]
        print(Styler.menu_message(options, title="USER MENU"))
        choice = int(input(Styler.choice_message("👉 Enter your choice (1-3): ")))
        return choice
    
    @staticmethod
    def display_game_modus_menu():
        options = ["Topics", "Difficulty"]
        print(Styler.menu_message(options, title="GAME MODUS"))
        choice = int(input(Styler.choice_message("👉 Enter your choice (1-2): ")))
        return choice
    
    @staticmethod
    def display_main_menu():
        options = ["Log in", "Register", "Exit"]
        print(Styler.menu_message(options, title="LOG MENU"))
        choice = int(input(Styler.choice_message("👉 Enter your choice (1-3): ")))
        return choice
    
    @staticmethod
    def display_admin_menu(modification, preposition):
        options = [
            f"➕ {modification} question {preposition} database",
            f"📂 {modification} topic {preposition} database",
            f"📑 {modification} module {preposition} database",
            f"📦 {modification} submodule {preposition} database",
            f"👤 {modification} user {preposition} database",
            "⬅️ Go back",
            "🚪 Log out"
        ]
        print(Styler.menu_message(options, title="ADMIN MENU"))
        choice = int(input(Styler.choice_message("👉 Enter your choice (1-7): ")))
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