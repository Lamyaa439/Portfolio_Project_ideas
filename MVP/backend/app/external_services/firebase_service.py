"""
Firebase Integration Service.
Handles Cloud Messaging (FCM) for notifications and Cloud Storage (FCS) 
for media management.
"""

import firebase_admin
from firebase_admin import credentials, messaging, storage
import os


# Configuration: Use environment variables for security with local fallbacks
SERVICE_ACCOUNT_KEY = os.getenv("FIREBASE_CREDENTIALS_PATH", "firebaseKey.json")
STORAGE_BUCKET_NAME = os.getenv("FIREBASE_STORAGE_BUCKET", "loven-88b0a.appspot.com")

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
            firebase_admin.initialize_app(cred, {
                'storageBucket': STORAGE_BUCKET_NAME
            })
            # Log successful initialization for server monitoring
            print("Firebase SDK: Successfully initialized (FCM + Storage).")
        except Exception as e: 
            # Catch and log any initialization errors gracefully
            print(f"Firebase SDK: Initialization failed: {e}")


# Auto-initialize Firebase when this module is imported
initialize_firebase()

# ==========================================
# 1. Cloud Messaging (Notifications)
# ==========================================

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
        print(f"FCM Error: Dispatch failed: {e}")
        return False
    
# ==========================================
# 2. Cloud Storage (Media Management)
# ==========================================
def delete_cloud_file(file_path: str) -> bool:
    """
    Removes a physical file from the cloud bucket to prevent orphaned storage.
    
    Args:
        file_path: The specific path/name of the file in the bucket.
    """
    if not file_path:
        return False

    try:
        bucket = storage.bucket()
        blob = bucket.blob(file_path)
        
        if blob.exists():
            blob.delete()
            print(f"FCS Success: Deleted {file_path}")
            return True
        return False
    except Exception as e:
        print(f"FCS Error: Deletion failed: {e}")
        return False