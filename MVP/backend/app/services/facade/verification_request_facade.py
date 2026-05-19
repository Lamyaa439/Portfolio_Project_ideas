from app.services.verification_request_service import (
    VerificationRequestService
)

class VerificationRequestFacade:

    @staticmethod
    def create_request(data):

        verification_request = (
            VerificationRequestService.create_request(
                data
            )
        )

        return verification_request.to_dict()

    @staticmethod
    def get_all_requests():

        requests = (
            VerificationRequestService.get_all_requests()
        )

        return [
            request.to_dict()
            for request in requests
        ]

    @staticmethod
    def get_request_by_id(request_id):

        verification_request = (
            VerificationRequestService.get_request_by_id(
                request_id
            )
        )

        return verification_request.to_dict()

    @staticmethod
    def update_request_status(
        request_id,
        status
    ):

        verification_request = (
            VerificationRequestService.update_request_status(
                request_id,
                status
            )
        )

        return verification_request.to_dict()
