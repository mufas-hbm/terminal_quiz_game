from database_manager import DatabaseManager
from menu import Menu
from question_manager import QuestionManager
from quiz import Quiz


def main():
    db_manager = DatabaseManager(dbname="quiz_data", user="hector", password="DciCurso2024it?", host="localhost", port="5432")
    db_manager.connect()

    quiz = Quiz(db_manager)
    question_manager = QuestionManager(db_manager)

    while True:
        choice = Menu.display_main_menu()

        if choice == '1':
            quiz.start()
        elif choice == '2':
            question_manager.add_question()
        elif choice == '3':
            print("Exiting the application. Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

    db_manager.close()

if __name__ == "__main__":
    main()
