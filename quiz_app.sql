--create database
CREATE DATABASE quiz_app;

-- go into databse
\c

-- create table topic
CREATE TABLE IF NOT EXISTS topics (
    topic_id SERIAL PRIMARY KEY;
    topic_name VARCHAR(50) NOT NULL UNIQUE,
    topic_description TEXT
);

-- create table module
CREATE TABLE IF NOT EXISTS modules (
    module_id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL,
    module_name VARCHAR(50) NOT NULL UNIQUE,
    module_description TEXT,

    CONSTRAINT fk_module_topic
        FOREIGN KEY (topic_id) 
        REFERENCES topics(topic_id)
);
-- create table submodule
CREATE TABLE IF NOT EXISTS submodules (
    submodule_id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL,
    submodule_name VARCHAR(50) NOT NULL,
    submodule_description TEXT,

    CONSTRAINT fk_submodule_module
        FOREIGN KEY (module_id) 
        REFERENCES modules(module_id)
);

-- create type ENUM for the question difficulty
CREATE TYPE difficulty_level as ENUM(1,2,3)

-- create table question
CREATE TABLE IF NOT EXISTS questions(
    question_id SERIAL PRIMARY KEY,
    submodule_id INTEGER, -- allow null values to create questions without a topic
    question_text TEXT NOT NULL,
    difficulty difficulty_level NOT NULL,
    explanation TEXT NOT NULL, --provide clarity and understanding regarding the correct answer.

    CONSTRAINT fk_questions_submmodule
        FOREIGN KEY (submodule_id)
        REFERENCES submodules(submodule_id)
)

-- create table answers
CREATE TABLE IF NOT EXISTS answers(
    answer_id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    answer TEXT NOT NULL,
    right_answer BOOLEAN NOT NULL,

    CONSTRAINT fk_questions_answers
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id)

);

-- create table users
CREATE TABLE IF NOT EXISTS users(
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
);

-- create table user_log
CREATE TABLE IF NOT EXISTS user_log(
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,

    CONSTRAINT fk_users_userlog
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

-- Insert values into topics table
INSERT INTO topics (topic_name, topic_description) VALUES
('Programming', 'All things programming'),
('Mathematics', 'Mathematical concepts'),
('History', 'Historical events and figures');

-- Insert values into modules table
INSERT INTO modules (topic_id, module_name, module_description) VALUES
(1, 'Python Basics', 'Fundamental Python concepts'),
(1, 'Data Structures', 'Common data structures'),
(2, 'Algebra', 'Algebraic equations and expressions'),
(2, 'Calculus', 'Differential and integral calculus'),
(3, 'World War II', 'Events of WWII'),
(3, 'Ancient Egypt', 'History of Ancient Egypt');

-- Insert values into submodules table
INSERT INTO submodules (module_id, submodule_name, submodule_description) VALUES
(1, 'Variables', 'Variable declaration and usage'),
(1, 'Loops', 'For and while loops'),
(2, 'Linked Lists', 'Singly and doubly linked lists'),
(2, 'Trees', 'Binary trees and traversals'),
(3, 'Linear Equations', 'Solving linear equations'),
(4, 'Derivatives', 'Calculating derivatives'),
(5, 'Battle of Britain', 'The aerial campaign'),
(6, 'Pharaohs', 'Rulers of Ancient Egypt');

-- Insert values into questions table
INSERT INTO questions (submodule_id, question_text, difficulty, explanation) VALUES
(1, 'What is the correct way to declare a variable in Python?', '1', 'Variables are declared using assignment operator.'),
(2, 'What is the purpose of a for loop?', '2', 'For loops iterate over a sequence.'),
(3, 'What is a linked list?', '2', 'A linked list is a linear data structure.'),
(4, 'What is a binary tree?', '3', 'A binary tree is a tree data structure.'),
(5, 'Solve for x: 2x + 5 = 11', '1', 'Subtract 5 and divide by 2.'),
(6, 'What is the derivative of x^2?', '3', 'The derivative is 2x.'),
(7, 'What was the Battle of Britain?', '2', 'An aerial campaign during WWII.'),
(8, 'Who was Hatshepsut?', '2', 'A female pharaoh of Egypt.');
(NULL, 'What is the capital of France?', '1', 'Paris is the capital of France.'), -- Question without a submodule
(NULL, 'Which planet is known as the "Red Planet"?', '1', 'Mars is the Red Planet.'); -- Question without a submodule

-- Insert values into answers table
INSERT INTO answers (question_id, answer, right_answer) VALUES
(1, 'x = 5', TRUE),
(1, 'var x = 5', FALSE),
(1, 'int x = 5', FALSE),
(2, 'To iterate over a sequence', TRUE),
(2, 'To define a class', FALSE),
(2, 'To print a message', FALSE),
(3, 'A linear data structure', TRUE),
(3, 'A non-linear data structure', FALSE),
(4, 'A tree data structure', TRUE),
(4, 'A graph data structure', FALSE),
(5, 'x = 3', TRUE),
(5, 'x = 4', FALSE),
(6, '2x', TRUE),
(6, 'x', FALSE),
(7, 'An aerial campaign', TRUE),
(7, 'A land battle', FALSE),
(8, 'A female pharaoh', TRUE),
(8, 'A male pharaoh', FALSE),
(9, 'Barcelona', FALSE),
(9, 'Milan', FALSE),
(9, 'Paris', TRUE),
(9, 'Egypt', False),
(10, 'Earth', False),
(10, 'Mars', TRUE),
(10, 'Jupiter', FALSE),
(10, 'Saturn', FALSE);


