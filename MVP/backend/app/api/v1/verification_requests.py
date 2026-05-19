from flask import Blueprint
from flask import jsonify
from flask import request

from app.services.facade.verification_request_facade import (
    VerificationRequestFacade
)

verification_requests_bp = Blueprint(
    "verification_requests",
    __name__
)


@verification_requests_bp.route(
    "/verification-requests",
    methods=["POST"]
)
def create_verification_request():

    data = request.get_json()

    result = (
        VerificationRequestFacade.create_request(
            data
        )
    )

    return jsonify(result), 201


@verification_requests_bp.route(
    "/verification-requests",
    methods=["GET"]
)
def get_all_verification_requests():

    result = (
        VerificationRequestFacade.get_all_requests()
    )

    return jsonify(result), 200


@verification_requests_bp.route(
    "/verification-requests/<request_id>",
    methods=["GET"]
)
def get_verification_request(request_id):

    result = (
        VerificationRequestFacade.get_request_by_id(
            request_id
        )
    )

    return jsonify(result), 200


@verification_requests_bp.route(
    "/verification-requests/<request_id>/status",
    methods=["PATCH"]
)
def update_verification_request_status(
    request_id
):

    data = request.get_json()

    result = (
        VerificationRequestFacade.update_request_status(
            request_id,
            data["status"]
        )
    )

    return jsonify(result), 200
