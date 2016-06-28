class OutdatedController < ApplicationController
  before_filter :authenticate
  layout 'cms'

  def index
    @report = OutdatedEventReport.new
    if @report.all_in_date?
      render text: 'All events are in date!'
    else
      render 'index'
    end
  end
end
