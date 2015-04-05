class AdminMailer < ActionMailer::Base
  default from: "swingoutlondon@gmail.com"

  def outdated
    @out_of_date_events       = Event.out_of_date
    @near_out_of_date_events  = Event.near_out_of_date

    subject  = "All events in date"

    if  @out_of_date_events.empty? && @near_out_of_date_events.empty?
      template = "all_in_date"
    else
      subject = "#{@out_of_date_events.count} #{'event'.pluralize(@out_of_date_events.count)} out of date" unless @out_of_date_events.empty?
      subject += ", #{@near_out_of_date_events.count} #{'event'.pluralize(@near_out_of_date_events.count)} nearly out of date" unless @near_out_of_date_events.empty?
      template = "outdated"
    end

    mail to: "swingoutlondon@gmail.com", subject: subject, template_name: template
  end
end
