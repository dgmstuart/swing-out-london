class OutdatedController < CMSBaseController
  def index
    @report = OutdatedEventReport.new
    if @report.all_in_date?
      render text: 'All events are in date!'
    else
      render 'index'
    end
  end
end
