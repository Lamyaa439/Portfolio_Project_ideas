from app.extensions import db
from sqlalchemy.dialects.postgresql import UUID

from app.models.base_model import BaseModel


# =========================================================
# Model: Report
# =========================================================
# Represents moderation reports submitted against artworks.
#
# Reports inherit audit metadata from BaseModel so the
# moderation lifecycle can be tracked consistently.
# =========================================================


class Report(BaseModel):

    __tablename__ = "reports"

    reporter_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey(
            "users.id",
            ondelete="CASCADE"
        ),
        nullable=False
    )

    target_artwork_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey(
            "artworks.id",
            ondelete="CASCADE"
        ),
        nullable=False
    )

    reason = db.Column(
        db.String(255),
        nullable=False
    )

    details = db.Column(
        db.Text,
        nullable=True
    )

    status = db.Column(
        db.String(50),
        default="open",
        nullable=True
    )

    def to_dict(self):

        return {
            "id": str(self.id) if self.id else None,

            "reporter_id": (
                str(self.reporter_id)
                if self.reporter_id
                else None
            ),

            "target_artwork_id": (
                str(self.target_artwork_id)
                if self.target_artwork_id
                else None
            ),

            "reason": self.reason,
            "details": self.details,
            "status": self.status,

            "created_at": (
                self.created_at.isoformat()
                if self.created_at
                else None
            ),

            "updated_at": (
                self.updated_at.isoformat()
                if self.updated_at
                else None
            ),
        }