# frozen_string_literal: true

class ValidSocialOrClass < ActiveModel::Validator
  def validate(event)
    socials_must_have_titles(event)
    classes_must_have_organisers(event)
    must_have_class_or_social(event)
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

  def must_have_class_or_social(event)
    return if event.has_class? || event.has_social?

    event.errors.add(:base, "Events must have either a Social or a Class, otherwise they won't be listed!")
  end
end
