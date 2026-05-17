from app.persistence.repositories.report_repo import (
    create_report,
)


# =========================================================
# Report Service
# =========================================================
# Centralizes validation rules for artwork reporting.
#
# The service layer ensures moderation-related data remains
# consistent before storage.
# =========================================================


def submit_report(data):

    reporter_id = data.get("reporter_id")
    target_artwork_id = data.get(
        "target_artwork_id"
    )
    reason = data.get("reason")
    details = data.get("details")

    # Reports must always be tied to an authenticated user
    # so abusive or anonymous moderation actions are avoided.
    if not reporter_id:
        return {"error": "reporter_id is required"}, 400

    # Moderation workflows depend on identifying the exact
    # artwork that triggered the report.
    if not target_artwork_id:
        return {
            "error": "target_artwork_id is required"
        }, 400

    # A report without a reason provides no actionable
    # context for moderators reviewing the case.
    if not reason:
        return {"error": "reason is required"}, 400

    report = create_report(
        reporter_id=reporter_id,
        target_artwork_id=target_artwork_id,
        reason=reason,
        details=details,
    )

    return {
        "message": "Report submitted successfully",
        "report": {
            "id": str(report[0]),
            "reporter_id": str(report[1]),
            "target_artwork_id": str(report[2]),
            "reason": report[3],
            "details": report[4],
            "status": report[5],
            "created_at": (
                report[6].isoformat()
                if report[6]
                else None
            ),
            "updated_at": (
                report[7].isoformat()
                if report[7]
                else None
            ),
        },
    }, 201