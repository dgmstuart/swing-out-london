# frozen_string_literal: true

require "spec_helper"
require "app/models/config"
require "active_support/core_ext/hash"

RSpec.describe Config do
  describe "#load" do
    it "loads config from a YAML file" do
      content = { "foo" => { "bar" => "baz" } }
      app_root = Pathname.new("/Users/me/dev/swing-out-london")
      yaml_loader = class_double(YAML, load_file: content)

      config = described_class.new(app_root:, yaml_loader:)
      config.load("qux.yml")

      expect(yaml_loader).to have_received(:load_file)
        .with("/Users/me/dev/swing-out-london/config/qux.yml")
    end

    it "returns the file content as a symbol hash" do
      content = { "foo" => { "bar" => "baz" } }
      app_root = Pathname.new("/")
      yaml_loader = class_double(YAML, load_file: content)

      config = described_class.new(app_root:, yaml_loader:)
      result = config.load("qux.yml")

      expect(result.fetch(:foo).fetch(:bar)).to eq "baz"
    end
  end
end
