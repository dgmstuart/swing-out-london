# frozen_string_literal: true

module ActionView
  class Template
    module Handlers
      class Markdown
        class_attribute :default_format
        self.default_format = Mime[:html]

        def call(_template, source)
          markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
          "#{markdown.render(source).inspect}.html_safe"
        end
      end
    end

    register_template_handler(:md, ActionView::Template::Handlers::Markdown.new)
    register_template_handler(:mdown, ActionView::Template::Handlers::Markdown.new)
    register_template_handler(:markdown, ActionView::Template::Handlers::Markdown.new)
  end
end
