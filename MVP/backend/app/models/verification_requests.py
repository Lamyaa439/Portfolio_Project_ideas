from app.extensions import db

from app.models.verification_request import (
    VerificationRequest
)

class VerificationRequestRepository:

    @staticmethod
    def create(data):

        verification_request = VerificationRequest(
            artist_profile_id=data["artist_profile_id"],
            document_type=data.get("document_type"),
            institution_name=data.get("institution_name"),
            document_number=data.get("document_number"),
            status="pending"
        )

        db.session.add(verification_request)
        db.session.commit()

        return verification_request

    @staticmethod
    def get_all():

        return VerificationRequest.query.all()

    @staticmethod
    def get_by_id(request_id):

        return VerificationRequest.query.get(request_id)

    @staticmethod
    def update_status(request_obj, status):

        request_obj.status = status

        db.session.commit()

        return request_obj
