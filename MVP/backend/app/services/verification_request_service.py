from app.persistence.repositories.verification_request_repo import (
    VerificationRequestRepository
)

class VerificationRequestService:

    @staticmethod
    def create_request(data):

        if not data.get("artist_profile_id"):
            raise ValueError(
                "artist_profile_id is required"
            )

        return (
            VerificationRequestRepository.create(data)
        )

    @staticmethod
    def get_all_requests():

        return (
            VerificationRequestRepository.get_all()
        )

    @staticmethod
    def get_request_by_id(request_id):

        verification_request = (
            VerificationRequestRepository.get_by_id(
                request_id
            )
        )

        if not verification_request:
            raise ValueError(
                "Verification request not found"
            )

        return verification_request

    @staticmethod
    def update_request_status(
        request_id,
        status
    ):

        verification_request = (
            VerificationRequestRepository.get_by_id(
                request_id
            )
        )

        if not verification_request:
            raise ValueError(
                "Verification request not found"
            )

        return (
            VerificationRequestRepository.update_status(
                verification_request,
                status
            )
        ) 
