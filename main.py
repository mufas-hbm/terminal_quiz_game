from managers.database_manager import DatabaseManager
from core.menu import Menu
from managers.input_manager import InputHandler
from core.quiz import Quiz
from managers.question_manager import QuestionManager
from admin import Admin
from config.setup_config import create_config, create_database
from managers.session_manager import SessionManager
from managers.style_manager import Styler


def main():
    #create_database()
    #db_config = create_config()
    db_config = {
    "dbname": "quiz_game",
    "user": "hector",
    "password": "DciCurso2024it?",
    "host": "localhost",
    "port": "5432"
}
    db_manager = DatabaseManager(**db_config)
    db_manager.connect()

    # Instantiate class objects
    input_handler = InputHandler()
    quiz = Quiz(db_manager, input_handler)
    question_manager = QuestionManager(db_manager, input_handler)
    admin_manager = Admin(db_manager, input_handler)
    session_manager = SessionManager(quiz,question_manager, admin_manager, db_manager, input_handler)

    print(Styler.title_message("---WELCOME THE THE QUIZ GAME---"))
    while True:
        choice = Menu.display_main_menu()
        if choice == 1:
            try:
                username = input_handler.get_username()
                password = input_handler.get_password()
                user_id = db_manager.log_user(username, password)[0]
                name = db_manager.get_name_actual_user(user_id)[0].strip()
            

                print(Styler.confirmation_message(f"\n🌟 Welcome, {name}! 🌟"))


                #set the logged status from actual as True in the db.
                db_manager.set_logged_status(name, True)

                if name == "admin":
                    session_manager.admin_session(name)
                else:
                    session_manager.player_session(name, username)
            except Exception as e:
                print(Styler.warning_message("username or password wrong, try again or register"))
        elif choice == 2:
            print("\n New user register\n")
            user_data = input_handler.register()
            new_user = db_manager.add_user(user_data)
            if new_user:
                print(Styler.confirmation_message(f"\n🎉 New user {user_data['name']} created successfully! 🎉"))
            else:
                print(Styler.error_message("Error creating new user"))
        elif choice == 3:
            print(Styler.confirmation_message("Exiting the application. Goodbye!"))
            break
        else:
            print(Styler.warning_message("Invalid choice. Please try again."))

    db_manager.close()

if __name__ == "__main__":
    main()
