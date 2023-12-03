# frozen_string_literal: true

module MapListingsHelper
  def mapinfo_social_listing(social_listing)
    capture do
      if social_listing.cancelled?
        concat cancelled_label
        concat " "
      end
      if social_listing.new?
        concat new_event_label
        concat " "
      end
      concat mapinfo_social_link(social_listing)
    end
  end

  def mapinfo_social_link(social)
    text = capture do
      concat social.title
      if social.has_class? || social.has_taster?
        concat " "
        concat mapinfo_class_info_tag(social)
      end
    end

    link_to text, social.url
  end

  def mapinfo_class_info_tag(social)
    class_type = social.has_class? ? "class" : "taster"

    class_info = []
    class_info << social.class_style if social.class_style.present?
    class_info << class_type

    tag.span class: "info" do
      concat "("
      concat class_info.join(" ")
      if school_name(social)
        concat " by "
        concat school_name(social)
      end
      concat ")"
    end
  end

  def mapinfo_swingclass_link(event)
    text = capture do
      concat "Class"
      concat " "
      concat mapinfo_swingclass_details(event)
      concat tag.span swingclass_info(event), class: "info" if swingclass_info(event)
    end

    link_to text, event.url
  end

  def mapinfo_swingclass_details(event)
    details = []
    details << new_event_label if event.new?
    details << "(from #{I18n.l(event.first_date, format: :short)})" unless event.started?
    details << "(#{event.class_style})" if event.class_style.present?
    details << "- #{event.course_length} week courses" unless event.course_length.nil?
    details.join(" ")
  end
end
