"""
Firebase Notification Service.
Handles sending FCM push notifications securely.
"""

import firebase_admin
from firebase_admin import credentials, messaging
import os

SERVICE_ACCOUNT_KEY = os.getenv("FIREBASE_CREDENTIALS_PATH", "firebaseKey.json")

def initialize_firebase():
    """
    Initializes the Firebase Admin SDK singleton.
    
    Ensures that the Firebase application is initialized only once. 
    This prevents 'ValueError: The default Firebase app already exists' 
    crashes during server hot-reloads or multiple module imports.
    """

    # Check if Firebase has already been initialized
    if not firebase_admin._apps:
        try:
            # Load the service account credentials
            cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
            # Initialize the Firebase application with the credentials
            firebase_admin.initialize_app(cred)
            # Log successful initialization for server monitoring
            print("Firebase Admin SDK initialized successfully.")
        except Exception as e: 
            # Catch and log any initialization errors gracefully
            print(f"Failed to initialize Firebase: {e}")


# Auto-initialize Firebase when this module is imported
initialize_firebase()

def send_welcome_notification(fcm_token: str, user_name: str) -> bool:
    """
    Dispatches a personalized welcome push notification to new users.

    Args:
        fcm_token (str): The FCM device token provided by the frontend.
        user_name (str): The user's name for personalizing the message.

    Returns:
        bool: True if the notification was sent successfully, False otherwise.
    """

    # Exit early if no token is provided
    if not fcm_token:
        print("No token provided. Skipping welcome notification.")
        return False
    
    # Construct the message payload
    message = messaging.Message(
        notification=messaging.Notification(
            title="Welcome to LOVEN! 🎨 ",
            body= f"Hi {user_name}, we're happy you are here!!",
        ),
        data={
            "type":"welcome_alert",
            "action": "open_home_screen"
        },
        token = fcm_token,
    )

    # attempt to send the message
    try:
        message_id = messaging.send(message)
        print(f"Welcome notification sent. ID: {message_id}")
        return True
    except Exception as e:
        print(f"Could not send welcome notification: {e}")
        return False
    