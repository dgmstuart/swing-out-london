# frozen_string_literal: true

class ValidSocialOrClass < ActiveModel::Validator
  def validate(event)
    socials_must_have_titles(event)
    classes_must_have_organisers(event)
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
end
