from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required

from app.services.facade.verification_request_facade import (
    VerificationRequestFacade,
)

verification_requests_bp = Blueprint(
    "verification_requests",
    __name__,
)


def _json_body():
    return request.get_json(silent=True) or {}


@verification_requests_bp.post("/verification-requests")
@jwt_required()
def create_verification_request():
    data = _json_body()

    result, status_code = VerificationRequestFacade.create_request(data)

    return jsonify(result), status_code


@verification_requests_bp.get("/verification-requests")
@jwt_required()
def get_all_verification_requests():
    result, status_code = VerificationRequestFacade.get_all_requests()

    return jsonify(result), status_code


@verification_requests_bp.get("/verification-requests/<request_id>")
@jwt_required()
def get_verification_request(request_id):
    result, status_code = VerificationRequestFacade.get_request_by_id(
        request_id,
    )

    return jsonify(result), status_code


@verification_requests_bp.patch("/verification-requests/<request_id>/status")
@jwt_required()
def update_verification_request_status(request_id):
    data = _json_body()

    status = data.get("status")
    if not status:
        return jsonify({"error": "status is required"}), 400

    result, status_code = VerificationRequestFacade.update_request_status(
        request_id,
        status,
    )

    return jsonify(result), status_code
