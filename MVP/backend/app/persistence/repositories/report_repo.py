import uuid
from sqlalchemy import text
from app.extensions import db


# =========================================================
# Report Repository
# =========================================================
# Handles persistence for artwork reports submitted by users.
#
# Reports are stored separately from artworks so moderation
# actions can be tracked independently from marketplace data.
# =========================================================


def create_report(
    reporter_id,
    target_artwork_id,
    reason,
    details=None,
    status="open",
):

    # Reports use UUIDs to avoid predictable identifiers and
    # stay aligned with the overall LOVEN schema design.
    report_id = str(uuid.uuid4())

    query = text("""
        INSERT INTO reports (
            id,
            reporter_id,
            target_artwork_id,
            reason,
            details,
            status
        )
        VALUES (
            :id,
            :reporter_id,
            :target_artwork_id,
            :reason,
            :details,
            :status
        )
        RETURNING
            id,
            reporter_id,
            target_artwork_id,
            reason,
            details,
            status,
            created_at,
            updated_at
    """)

    result = db.session.execute(query, {
        "id": report_id,
        "reporter_id": reporter_id,
        "target_artwork_id": target_artwork_id,
        "reason": reason,
        "details": details,
        "status": status,
    })

    # Reports should persist immediately so moderation data
    # is never lost during the review workflow.
    db.session.commit()

    return result.fetchone()