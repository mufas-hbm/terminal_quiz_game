class InputHandler:
    """Handles user input for question details."""

    def get_topic(self):
        return input("Enter the topic for the question: ")

    def get_module(self):
        return input("Enter the module: ")

    def get_submodule(self):
        return input("Enter the submodule: ")

    def get_difficulty(self):
        while True:
            try:
                difficulty = int(input("Enter the difficulty level (1-3): "))
                if 1 <= difficulty <= 3:
                    return difficulty
                else:
                    print("Difficulty level must be between 1 and 3.")
            except ValueError:
                print("Invalid input. Please enter a number.")

    def get_question(self):
        return input("Enter the question: ")

    def get_correct_answer(self):
        return input("Enter the correct answer: ")

    def get_wrong_answers(self):
        wrong_answers = []
        for i in range(2, 6):  # Collect 2 to 5 wrong answers
            wrong = input(f"Enter wrong answer {len(wrong_answers) + 1} (leave blank to stop): ")
            if wrong:
                wrong_answers.append(wrong)
            else:
                break
        return wrong_answers