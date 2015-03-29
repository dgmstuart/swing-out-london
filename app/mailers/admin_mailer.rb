class AdminMailer < ActionMailer::Base
  default from: "swingoutlondon@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.outdated.subject
  #
  def outdated
    @greeting = "Hi"

    @out_of_date_events       = Event.out_of_date
    @near_out_of_date_events  = Event.near_out_of_date

    subject = "All events in date"
    subject = "#{@out_of_date_events.count} #{'event'.pluralize(@out_of_date_events.count)} out of date" unless @out_of_date_events.empty?
    subject += ", #{@near_out_of_date_events.count} #{'event'.pluralize(@near_out_of_date_events.count)} nearly out of date" unless @near_out_of_date_events.empty?

    mail to: "swingoutlondon@gmail.com", subject: subject
  end
end
