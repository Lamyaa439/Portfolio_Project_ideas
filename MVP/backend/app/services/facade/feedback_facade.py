from app.services.feedback_service import (
    submit_feedback,
)


# =========================================================
# Feedback Facade
# =========================================================
# The facade acts as the orchestration layer between APIs
# and services.
#
# Keeping APIs thin makes future changes easier, especially
# if workflows later expand to:
# - moderation tools
# - analytics
# - admin dashboards
# =========================================================


class FeedbackFacade:

    @staticmethod
    def create_feedback(data):

        return submit_feedback(data)