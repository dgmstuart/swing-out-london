# frozen_string_literal: true

class AuditLogsController < CMSBaseController
  def show
    @audits = Audit.all.order(created_at: :desc)
  end
end
