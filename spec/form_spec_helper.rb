# frozen_string_literal: true

require "spec_helper"
require "active_model"
require "factory_bot"
require "spec/support/forms/shoulda_matchers"

FactoryBot.find_definitions if FactoryBot.factories.none?

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Shoulda::Matchers::ActiveModel
end

# MONKEY PATCH
module Shoulda
  module Matchers
    module RailsShim
      class << self
        def serialized_attributes_for(model)
          # the real definition depends on ::ActiveRecord::Type::Serialized, which we're not loading in these isolated specs:
          # https://github.com/thoughtbot/shoulda-matchers/issues/1553
          attribute_types_for(model)
        end
      end
    end
  end
end

# Add locale to the path for Faker
I18n.load_path << "./config/locales/en.yml"

def stub_model_name(model_class_name)
  model_name = instance_double("ActiveModel::Name", human: model_class_name.downcase, i18n_key: model_class_name.downcase.to_sym)
  stub_const(model_class_name, class_double(model_class_name, model_name:))
end
