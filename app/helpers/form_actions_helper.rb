# frozen_string_literal: true

module FormActionsHelper
  def conditional_delete_tag(resource)
    return unless resource.persisted?

    confirmation = "Are you sure you want to delete this?"
    link_to_if resource.can_delete?, "Delete", resource, data: { confirm: confirmation }, method: :delete, class: "button button-danger" do
      tag.span("Can't be deleted: has associated events", class: "inactive")
    end
  end
end
