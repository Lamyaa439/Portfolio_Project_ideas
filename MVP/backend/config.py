import os
from dotenv import load_dotenv

"""
This file connects the Flask app to the database.
"""

load_dotenv() # This line loads the .env file.


class Config:
    # connect the app to PostgreSQL
    DB_HOST = os.getenv("DB_HOST")
    DB_NAME = os.getenv("DB_NAME")
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_PORT = os.getenv("DB_PORT")

    # the line here builds the database connection URL.
    """
    Since we use a PostgreSQL database, this will connect to the PostgreSQL
    database running on the AWS server (16.170.246.241), port 5432, 
    and use the database loven_main_db.
    """
    SQLALCHEMY_DATABASE_URI = (
        f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # the 3 lines below tell Flask how to run the backend server

    # 1- read FLASK_DEBUG from .env and convert it into True or False
    DEBUG = os.getenv("FLASK_DEBUG", "True").lower() == "true"
    # 2- read the server host from .env, if the HOST missing use 0.0.0.0
    HOST = os.getenv("HOST", "0.0.0.0")
    # 3- read the port from .env then convert it to int
    PORT = int(os.getenv("PORT", "5000"))
