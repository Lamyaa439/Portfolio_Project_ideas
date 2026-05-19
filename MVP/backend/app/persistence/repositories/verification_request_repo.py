from app.extensions import db

from app.models.verification_request import (
    VerificationRequest,
)


class VerificationRequestRepository:
    VALID_STATUSES = {
        "pending",
        "approved",
        "rejected",
    }

    @staticmethod
    def create(data):
        verification_request = VerificationRequest(
            artist_profile_id=data["artist_profile_id"],
            document_type=data.get("document_type"),
            institution_name=data.get("institution_name"),
            document_number=data.get("document_number"),
            status="pending",
        )

        db.session.add(verification_request)
        db.session.commit()

        return verification_request

    @staticmethod
    def get_all():
        return VerificationRequest.query.order_by(
            VerificationRequest.created_at.desc()
        ).all()

    @staticmethod
    def get_by_id(request_id):
        return db.session.get(
            VerificationRequest,
            request_id,
        )

    @staticmethod
    def update_status(
        verification_request,
        status,
    ):
        if status not in VerificationRequestRepository.VALID_STATUSES:
            raise ValueError(
                "status must be pending, approved, or rejected"
            )

        verification_request.status = status

        db.session.commit()

        return verification_request
