# frozen_string_literal: true

class ValidSocialOrClass < ActiveModel::Validator
  def validate(event)
    socials_must_have_titles(event)
    classes_must_have_organisers(event)
    one_off_socials_occasional(event)
    no_one_off_workshops(event)
  end

  private

  def socials_must_have_titles(event)
    return unless event.has_social?
    return if event.title.present?

    event.errors.add(:title, "must be present for social dances")
  end

  def classes_must_have_organisers(event)
    return unless event.has_class? && event.class_organiser_id.nil?

    event.errors.add(:class_organiser_id, "must be present for classes")
  end

  def one_off_socials_occasional(event)
    return unless event.has_social? && event.weekly? && one_off(event)

    event.errors.add(:frequency, 'must be "Monthly or occasionally" if a social is only happening once')
  end

  def no_one_off_workshops(event)
    return unless event.has_class? && one_off(event) && !event.has_social?

    message = <<~MESSAGE.chomp
      It looks like you're trying to list a one-off workshop.
      Please don't do this: we only list weekly classes on SOLDN.
    MESSAGE
    event.errors.add(:base, message)
  end

  def one_off(event)
    event.first_date.present? && event.first_date == event.last_date
  end
end
