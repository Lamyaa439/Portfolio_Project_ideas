"""
Authentication Facade:
acts as the Orchestrator. It delegates the core business logic to the auth_service,
and coordinates with external services (like Firebase/Notifications) 
without cluttering the core service logic.
"""

from app.services.auth_service import register_user, login_user
from app.external_services.notification_service import send_welcome_notification

class AuthFacade:

    @staticmethod
    def register(data: dict):
        """
        Manages the new user registration process
        Args:
            data (dict): user registration details
        returns: 
            tuple: (response data, HTTP status code)
        """
        result, status_code = register_user(data)

        # if registration is successful (201 Created)
        if status_code == 201:
            user_name = data.get("name", "Dear artist")
            fcm_token = data.get("fcm_token")

            # Firebase welcome notification
            if fcm_token:
                try:
                    send_welcome_notification(fcm_token, user_name)
                except Exception as e:
                    # Log the error, but don't fail the registration if Firebase is down
                    print(f"Failed to send welcome notification: {e}")

        # return the final result to the API
        return result, status_code
    
    @staticmethod
    def login(data: dict):
        """
        Manages the login process.
        Args:
            data (dict): Login details including the FCM token.

        Returns:
            tuple: (response data, HTTP status code)
        """
        # The database update for the FCM token is now securely handled inside login_user!
        result, status_code = login_user(data)
        return result, status_code