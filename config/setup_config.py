import json
import os
import psycopg2

def create_config():
    print("Welcome to the Quiz Game Configuration Setup!")
    print("Please provide the following details for database configuration:\n")
    
    # Prompting user for database credentials
    dbname = input("Enter the database name: ").strip()
    user = input("Enter the database username: ").strip()
    password = input("Enter the database password: ").strip()
    host = input("Enter the database host (default: localhost): ").strip() or "localhost"
    port = input("Enter the database port (default: 5432): ").strip() or "5432"

    db_config = {
                "dbname": dbname,
                "user": user,
                "password": password,
                "host": host,
                "port": port
            }
    # Writing to db_config.py
    try:
        with open("config/db_config.py", "w") as config_file:
            config_file.write("db_config = " + json.dumps(db_config, indent=4))  # Convert dict to string
        print("\nConfiguration completed successfully!")
        print("Your database configuration has been saved to 'db_config.py'.")
    except Exception as e:
        print(f"\nAn error occurred while saving the configuration: {e}")
    return db_config


def create_database():
    """
    Creates the database and initializes its tables using quiz_game.sql.
    """

    # Prompting user for default database credentials
    dbname = input("Enter the database name: ").strip()
    user = input("Enter the database username: ").strip()
    password = input("Enter the database password: ").strip()
    host = input("Enter the database host (default: localhost): ").strip() or "localhost"
    port = input("Enter the database port (default: 5432): ").strip() or "5432"
    
    # Default connection to PostgreSQL server (commonly connects to 'postgres' database)
    default_connection = {
        "dbname": dbname,  
        "user": user, 
        "password": password,  
        "host": host,
        "port": port,
    }

    target_db_name = "quiz_game"  # Database name defined in your SQL file
    sql_file_path = os.path.join("src", "quiz_game.sql") 

    try:
        # Connect to the default PostgreSQL database
        conn = psycopg2.connect(**default_connection)
        conn.autocommit = True  # Enable autocommit
        cursor = conn.cursor()

        # Check if the target database exists
        cursor.execute(f"SELECT 1 FROM pg_database WHERE datname = '{target_db_name}'")
        if cursor.fetchone():
            print(f"Database '{target_db_name}' already exists.")
        else:
            # Create the target database
            print(f"Database '{target_db_name}' does not exist. Creating it...")
            cursor.execute(f"CREATE DATABASE {target_db_name}")
            print(f"Database '{target_db_name}' created successfully.")

        # Close the default connection
        cursor.close()
        conn.close()

        # Connect to the newly created database
        target_connection = default_connection.copy()
        target_connection["dbname"] = target_db_name
        conn = psycopg2.connect(**target_connection)
        cursor = conn.cursor()

        # Execute the SQL file to create tables
        if os.path.exists(sql_file_path):
            with open(sql_file_path, "r") as sql_file:
                sql_script = sql_file.read()
                cursor.execute(sql_script)
                conn.commit()
                print(f"Database structure initialized from '{sql_file_path}'.")
        else:
            print(f"SQL file '{sql_file_path}' not found. Please check the path.")

        # Close the connection
        cursor.close()
        conn.close()

    except Exception as e:
        print(f"An error occurred during database setup: {e}")
