# frozen_string_literal: true

class OutdatedController < CmsBaseController
  def index
    @report = OutdatedEventReport.new
    if @report.all_in_date?
      render plain: 'All events are in date!'
    else
      render 'index'
    end
  end
end
