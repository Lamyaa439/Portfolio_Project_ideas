from app.services.report_service import (
    submit_report,
)


# =========================================================
# Report Facade
# =========================================================
# The facade keeps API routes lightweight while preparing
# the reporting flow for future moderation integrations.
#
# Examples:
# - admin moderation queues
# - automated flagging systems
# - notification workflows
# =========================================================


class ReportFacade:

    @staticmethod
    def create_report(data):

        return submit_report(data)