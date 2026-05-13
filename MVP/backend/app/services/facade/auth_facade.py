"""
Authentication Facade:
acts as the Orchestrator. It delegates the core business logic to the auth_service,
and coordinates with external services (like Firebase/Notifications) 
without cluttering the core service logic.
"""

from app.services.auth_service import register_user, login_user
from MVP.backend.app.external_services.firebase_service import send_welcome_notification
from app.persistence.repositories.user_repo import UserRepository

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
    
    @staticmethod
    def logout(user_id: str):
        """
        Manages the logout process.
        Clears the FCM token to prevent push notifications to a logged-out device.
        Args:
            user_id (str): The ID of the user logging out.

        Returns:
            tuple: (response data, HTTP status code)
        """
        try:
            # Instantiate the repository and clear the fcm token
            user_repo = UserRepository()
            user_repo.update_fcm_token(user_id, None)
            
            return {"message": "Logged out successfully and notifications disabled for this device."}, 200
        except Exception as e:
            print(f"Error during logout: {e}")
            return {"error": "An internal error occurred during logout"}, 500