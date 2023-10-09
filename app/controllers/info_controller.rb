# frozen_string_literal: true

class InfoController < ApplicationController
  before_action :set_cache_control_on_static_pages, only: %i[about listings_policy privacy]

  def about
    @page = AboutPage
  end

  def listings_policy
    @page = ListingsPolicyPage
  end

  def privacy; end

  private

  def set_cache_control_on_static_pages
    # Varnish will cache the page for 43200 seconds = 12 hours:
    response.headers["Cache-Control"] = "public, max-age=43200"
  end

  class Page
    def initialize(root:, content_partials:, sidebar_partials:)
      @root = root
      @content_partials = content_partials
      @sidebar_partials = sidebar_partials
    end

    def content_partials
      @content_partials.map { Partial.new(@root, _1) }
    end

    def sidebar_partials
      @sidebar_partials.map { Partial.new(@root, _1) }
    end

    class Partial
      def initialize(root, path)
        @root = root
        @path = path
      end

      def path
        File.join(@root, @path)
      end

      def name
        File.basename(path)
      end
    end
  end

  AboutPage = Page.new(
    root: "info/about",
    content_partials: %w[
      about_swingoutlondon
    ],
    sidebar_partials: %w[
      about_us
      about_lindy
      show_love
    ]
  )

  ListingsPolicyPage = Page.new(
    root: "info/listings_policy",
    content_partials: %w[
      intro
      location_text
      classes_text
      classes_policy
      socials_text
      socials_policy
      music_text
    ],
    sidebar_partials: %w[
      swing_music
    ]
  )
end
