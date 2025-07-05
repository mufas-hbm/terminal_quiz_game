# Quiz Application - Class Structure and Functionality

This document outlines the class structure and functionality of the quiz application.

## Core Classes

### `DatabaseManager`

**Purpose:** Handles connection and interaction with the PostgreSQL database.

**Responsibilities:**

* Establishes and manages the connection to the PostgreSQL database.
* Executes SQL queries for data retrieval, insertion, updating, and deletion.
* Handles database transactions and error management.
* Provides methods for fetching questions, storing quiz results, and other database-related operations.

**Key Functionality:**

* Connection management (connect, disconnect).
* Query execution (SELECT, INSERT, UPDATE, DELETE).
* Data retrieval (fetching questions, user scores).
* Data persistence (saving quiz results, adding new questions).

### `QuestionManager`

**Purpose:** Manages adding new questions to the database.

**Responsibilities:**

* Provides an interface for users to add new questions, answer options, and correct answers.
* Validates user input.
* Inserts new questions into the database using the `DatabaseManager`.

**Key Functionality:**

* Prompting user for question details (question text, answer options, correct answer).
* Validating input data.
* Adding new questions to the database.
### `Menu`

**Purpose:** Manages user input and displays menus.

**Responsibilities:**

* Presents interactive menus to the user.
* Navigates between different sections of the application.
* Displays relevant information to the user.

**Key Functionality:**

* Displaying main menu, quiz menus, and question management menus.
* Directing program flow based on user input.

### `Quiz`

**Purpose:** Handles the quiz-taking functionality.

**Responsibilities:**

* Manages the quiz-taking process.
* Retrieves questions from the database through the `DatabaseManager`.
* Presents questions to the user and collects answers.
* Calculates the user's score.
* Stores the quiz results using the `DatabaseManager`.

**Key Functionality:**

* Fetching quiz questions.
* Presenting questions and answer options.
* Recording user answers.
* Calculating and displaying quiz scores.
* Saving quiz results to the database.

## System Workflow

1.  **Initialization:** The application initializes the `DatabaseManager` to establish a connection to the database.
2.  **Menu Display:** The `Menu` class displays the main menu, allowing the user to choose between taking a quiz, adding questions, or exiting.
3.  **Quiz Taking:** If the user chooses to take a quiz, the `Quiz` class retrieves questions from the database, presents them to the user, and calculates the score.
4.  **Question Management:** If the user chooses to add questions, the `QuestionManager` class prompts the user for question details and inserts them into the database.
5.  **Data Persistence:** The `DatabaseManager` handles all database interactions, ensuring data persistence and integrity.
6.  **Menu Navigation:** The `Menu` class manages navigation between different sections of the application, allowing the user to return to the main menu or exit.
7.  **Termination:** The application terminates when the user chooses to exit.

## Future Enhancements

* User authentication and profiles.
* Different quiz categories and difficulty levels.
* Detailed quiz result analysis and reporting.
* Graphical User Interface.
* Error handling improvements.
* Input validation improvements.