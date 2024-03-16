# frozen_string_literal: true

module Admin
  class AuditLogsController < BaseController
    def show
      @audits = AuditLogEntry.all
    end
  end
end
