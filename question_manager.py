
class QuestionManager:
    def __init__(self, db_manager, input_handler=None):
        self.db_manager = db_manager
        self.input_handler = input_handler

    def add_question(self):
        topic = self.input_handler.get_topic()
        module = self.input_handler.get_module()
        submodule = self.input_handler.get_submodule()
        difficulty = self.input_handler.get_difficulty()
        question = self.input_handler.get_question()
        correct_answer = self.input_handler.get_correct_answer()
        wrong_answers = self.input_handler.get_wrong_answers()

        try:
            cursor = self.db_manager.conn.cursor()
            query = """
                INSERT INTO quiz_questions 
                (topic, module, submodule, difficulty, question, correct_answer, wrong_answers)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (topic, module, submodule, difficulty, question, correct_answer, wrong_answers))
            self.db_manager.conn.commit()
            print("Question added successfully!")
        except Exception as e:
            print("Error adding question:", e)



# input_handler = InputHandler()
# question_manager = QuestionManager(db_manager, input_handler)
# question_manager.add_question()