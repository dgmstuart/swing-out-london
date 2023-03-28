# frozen_string_literal: true

module OrganisersHelper
  def organiser_row_tag(organiser)
    class_string = class_names(no_future_dates: organiser.no_future_dates?)

    tag :tr, { class: class_string, id: "organiser_#{organiser.id}" }, true
  end
end
