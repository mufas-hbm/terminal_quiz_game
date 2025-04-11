import time
# import sys
# import select
import pwinput
import re
from managers.style_manager import Styler

class InputHandler:
    """Handles user input for questions and answers."""

    def get_topic(self):
        """
        Prompts the user to enter a topic.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The topic entered by the user.
        """
        while True:
            topic = input("Enter a topic: ").strip()
            if topic:
                return topic
            else:
                print(Styler.warning_message("Topic cannot be empty, please write."))

    def get_module(self):
        """
        Prompts the user to enter a module.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The module entered by the user.
        """
        while True:
            module = input("Enter a module: ").strip()
            if module:
                return module
            else:
                print(Styler.warning_message("Module cannot be empty, please write."))

    def get_submodule(self):
        """
        Prompts the user to enter a submodule.
        If the input is empty, returns None (to allow general questions without topic al least).
        Returns:
            str or None: The submodule entered by the user, or None if empty.
        """
        submodule = input("Enter a submodule: ")
        if submodule == "":
            return None
        else:
            return submodule
        
    def get_input(self, level):
        """
        Prompts the user to enter a value for the given level (e.g., topic, module, submodule).
        Repeats the prompt until the user provides a non-empty input for mandatory levels.
        Allows an empty input for submodule and returns None in that case.
        
        Args:
            level (str): The name of the level (e.g., 'topic', 'module', 'submodule').
        
        Returns:
            str or None: The input provided by the user for the level.
        """
        while True:
            user_input = input(f"Enter a {level}: ").strip()

            # Allow empty input only for 'submodule'
            if user_input:
                return user_input
            elif level == "submodule":
                return None
            else:
                print(Styler.warning_message(f"{level.capitalize()} cannot be empty, please write."))

    def get_description(self):
        """
        Prompts the user to enter a description.
        If the input is empty, returns None.
        Returns:
            str or None: The description entered by the user, or None if empty.
        """
        description = input("Enter a description: ")
        if description == "":
            return None
        else:
            return description
        
    def get_difficulty(self):
        """
        Prompts the user to enter a difficulty level.
        Accepts only 'easy', 'medium', or 'hard'.
        Repeats the prompt until a valid input is provided.
        Returns:
            str: The difficulty level entered by the user.
        """
        levels = ['easy', 'medium', 'hard']
        while True:    
            difficulty = input("Enter the difficulty level (easy, medium, hard): ")
            if difficulty in levels:
                return difficulty
            else:
                print(Styler.warning_message("Difficulty level must be one of the possibilities"))

    def get_question_text(self):
        """
        Prompts the user to enter a question.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The question text entered by the user.
        """
        while True:
            question = input("Enter a question: ").strip()
            if question:
                return question
            else:
                print("Question cannot be empty, please write.")

    def get_explanation(self):
        """
        Prompts the user to enter an explanation.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The explanation entered by the user.
        """
        while True:
            explanation = input("Enter the explanation: ").strip()
            if explanation:
                return explanation
            else:
                print(Styler.warning_message("Explanation is important, please write."))
    
    def get_hint(self):
        """
        Prompts the user to enter a hint.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The hint entered by the user.
        """
        while True:
            hint = input("Enter the hint: ").strip()
            if hint:
                return hint
            else:
                print(Styler.warning_message("Hint helps player to find the answer, please write."))

    def get_correct_answer(self):
        """
        Prompts the user to enter the correct answer.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The correct answer entered by the user.
        """
        while True:
            correct_answer = input("Enter the correct answer: ").strip()
            if correct_answer:
                return correct_answer
            else:
                print(Styler.warning_message("Correct answer cannot be empty. Please try again."))

    def get_wrong_answers(self):
        """
        Prompts the user to enter up to six wrong answers.
        Collects at least two wrong answers before allowing the user to stop.
        Returns:
            list: A list of wrong answers provided by the user.
        """
        wrong_answers = []
        for i in range(6):  # Collect 2 to 5 wrong answers
            wrong = input(f"Enter wrong answer {len(wrong_answers) + 1} (leave blank to stop): ")
            if wrong:
                wrong_answers.append(wrong)
            else:
                if len(wrong_answers) >= 2:
                    break  # Allow stopping only after collecting at least 2 answers
                else:
                    print(Styler.warning_message("You must enter at least 2 wrong answers before stopping."))
        return wrong_answers

    # def quiz_get_user_answer(self):
    #     """
    #     Prompts the user to input an answer within a 15-second time limit.
        
    #     Returns:
    #         int: The user's input as an integer if valid.
    #         None: If no input is received within 15 seconds or the input is not a digit.
    #     """
    #     print("\nInput an answer (you have 15 seconds): ")

    #     ready, _, _ = select.select([sys.stdin], [], [], 15)
    #     if ready:
    #         answer = sys.stdin.read(1).strip()  # Reads one character automatically
    #         return int(answer) if answer.isdigit() else None
    #     return None
    def quiz_get_user_answer(self):
        return input("\nYour answer: ")
    
    def get_username(self):
        """
        Prompts the user to enter a username.
        Repeats the prompt until the user provides a non-empty input.
        Returns:
            str: The username text entered by the user.
        """
        while True:
            question = input("Enter your username: ").strip()
            if question:
                return question
            else:
                print(Styler.warning_message("username cannot be empty, please write."))
    
    def get_password(self):
        """
        Prompt the user to securely enter a password, ensuring it meets specified criteria.

        This method uses the `pwinput` library to conceal user input during password entry by masking it. 
        It validates the password against the following criteria:
        - The password must be at least 6 characters long.
        - It must include at least one numeric digit.
        - It must contain at least one special character (e.g., !, @, #, etc.).
        If the password is invalid or empty, the user is prompted to try again until a valid password is provided.

        Returns:
            str: A valid password entered by the user that adheres to the defined criteria.

        Notes:
            - The password input is masked using asterisks (*) for security.
            - If the `pwinput` library is unavailable or fails to function properly, an error message will be displayed.

        Raises:
            ValueError: If the `pwinput` library is not installed or if any unexpected failure occurs during input.
        """

        # Regex pattern for the password
        password_pattern = r"^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z0-9!@#$%^&*(),.?\":{}|<>]{6,}$"
        pattern = re.compile(password_pattern)
        while True:
            password = pwinput.pwinput(prompt="Enter your password: ", mask="*").strip()
            if not password:
                print(Styler.warning_message("password cannot be empty, please write."))
            elif not pattern.match(password):
                print(Styler.warning_message("Invalid password! Make sure it is at least 6 characters long, includes at least one number, and one special character."))
            else:
                return password

    def register(self):
        """
        Registers a new user by collecting their name, username, and password.

        Prompts the user for their name and ensures it's not empty.
        Then calls methods to get a unique username and a hashed password.
        Stores the collected information in a dictionary.

        Returns:
            dict: A dictionary containing the new user's registration data
                with keys "name", "username", and "hashed_password".
        """
        user_data: dict = {}
        while True:
            name = input("Enter your name: ").strip()
            if not name:
                print(Styler.warning_message("name cannot be empty, please write."))
            else:
                username = self.get_username()
                hashed_password = self.get_password()
                user_data = {
                    "name": name,
                    "username": username,
                    "hashed_password": hashed_password
                }
                return user_data
    
    def get_modification_type(self):
        """
        Prompts the admin user to choose between inserting, removing or updating data.

        The input is validated to ensure it matches either 'insert',  'remove' or 'update'.
        The loop continues until a valid input is provided.

        Returns:
            str: The chosen modification type ('insert', 'remove' or 'update').
        """
        modification_type = ['insert', 'remove', 'update']
        while True:    
            modification = input("Do you want to insert, remove or update data from database: ")
            if modification in modification_type:
                return modification
            else:
                print(Styler.warning_message("Invalid input, please try again"))
    
    def modify_description(self):
        categories = ['topic','module', 'submodule']
        while True:    
            category = input(f"from which category you want to change the description ({categories}:)")
            if category in categories:
                return category
            else:
                print(Styler.warning_message("Invalid input, please try again"))

            