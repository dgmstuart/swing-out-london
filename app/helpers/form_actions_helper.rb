# frozen_string_literal: true

module FormActionsHelper
  def conditional_delete_tag(resource)
    return unless resource.persisted?

    data = { turbo: true, turbo_confirm: "Are you sure you want to delete this?", turbo_method: :delete }
    link_to_if resource.can_delete?, "Delete", resource, data:, class: "button button-danger" do
      tag.span("Can't be deleted: has associated events", class: "inactive")
    end
  end
end
