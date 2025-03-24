import random
from menu import Menu

class Quiz:
    def __init__(self, db_manager):
        self.db_manager = db_manager

    def fetch_questions(self, topic, num_questions=5):
        try:
            cursor = self.db_manager.conn.cursor()
            query = """
                SELECT question, correct_answer, wrong_answers 
                FROM quiz_questions WHERE topic = %s 
                ORDER BY RANDOM() LIMIT %s
            """
            cursor.execute(query, (topic, num_questions))
            return cursor.fetchall()
        except Exception as e:
            print("Error fetching questions:", e)
            return []

    def start(self):
        topic = Menu.display_topic_menu()
        questions = self.fetch_questions(topic)

        if not questions:
            print("No questions available for this topic.")
            return

        score = 0
        for idx, (question, correct_answer, wrong_answers) in enumerate(questions, 1):
            print(f"\nQuestion {idx}: {question}")

            # Shuffle and display options
            options = [correct_answer] + wrong_answers
            random.shuffle(options)
            for i, option in enumerate(options, 1):
                print(f"{i}. {option}")

            # Get user input and check answer
            try:
                user_answer = int(input("Your answer (1-4): "))
                if options[user_answer - 1] == correct_answer:
                    print("Correct!")
                    score += 1
                else:
                    print(f"Wrong! The correct answer was: {correct_answer}")
            except ValueError:
                print("Invalid input! Moving to the next question.")

        print(f"\nYour final score: {score}/{len(questions)}")
