# frozen_string_literal: true

module Maps
  module Socials
    # Presenter for the map sidebar menu which lists the dates on which there
    # might be events
    class MenuDate
      def initialize(date:, selected:)
        @date = date
        @selected = selected
      end

      def to_s
        I18n.l(@date, format: :listing_date)
      end

      def to_param
        @date.to_fs(:db)
      end

      def selected?
        @selected
      end

      def events?
        EventInstance.exists?(date: @date) || Event.weekly_socials_on(@date).exists?
      end

      def sunday?
        @date.sunday?
      end
    end
  end
end
