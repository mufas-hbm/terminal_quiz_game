class Menu:
    @staticmethod
    def display_main_menu():
        print("\nMain Menu:")
        print("1. Take a Quiz")
        print("2. Add a New Question")
        print("3. Exit")
        choice = input("Enter your choice (1-3): ")
        return choice

    @staticmethod
    def display_topic_menu():
        topic = input("Enter the quiz topic: ")
        return topic