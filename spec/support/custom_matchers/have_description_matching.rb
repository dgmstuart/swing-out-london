# frozen_string_literal: true

module HaveDescriptionMatching
  extend RSpec::Matchers::DSL

  matcher :have_description_matching do |expected_description_regex|
    match do |page|
      description = page.find('meta[name="description"]', visible: false)["content"]
      description.match?(expected_description_regex)
    end

    failure_message do |page|
      "expected #{page.document.title} to include #{expected_description_regex}, got #{page.text}"
    end

    failure_message_when_negated do |page|
      "expected #{page.document.title} not to include #{expected_description_regex}"
    end
  end
end
