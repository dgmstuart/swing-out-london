# frozen_string_literal: true

module Admin
  class AuditLogsController < BaseController
    def show
      @audits = Audit.order(created_at: :desc).map { AuditLogEntry.new(_1) }
    end
  end
end
