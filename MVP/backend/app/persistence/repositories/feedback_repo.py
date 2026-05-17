import uuid
from sqlalchemy import text
from app.extensions import db


# =========================================================
# Feedback Repository
# =========================================================
# This layer isolates all SQL related to feedback records.
# Keeping queries here prevents database logic from leaking
# into services or API endpoints.
# =========================================================


def create_feedback(user_id, subject, message):

    # Feedback IDs are always generated server-side to keep
    # resource creation controlled and consistent.
    feedback_id = str(uuid.uuid4())

    query = text("""
        INSERT INTO feedback (
            id,
            user_id,
            subject,
            message
        )
        VALUES (
            :id,
            :user_id,
            :subject,
            :message
        )
        RETURNING
            id,
            user_id,
            subject,
            message,
            created_at
    """)

    result = db.session.execute(query, {
        "id": feedback_id,
        "user_id": user_id,
        "subject": subject,
        "message": message,
    })

    # Feedback submission should immediately persist so the
    # platform can reliably track user suggestions/issues.
    db.session.commit()

    return result.fetchone()