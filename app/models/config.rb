# frozen_string_literal: true

class Config
  def initialize(app_root: Rails.root, yaml_loader: YAML)
    @app_root = app_root
    @yaml_loader = yaml_loader
  end

  def load(file_name)
    file_path = app_root.join("config", file_name).to_s
    yaml_loader.load_file(file_path).deep_symbolize_keys
  end

  private

  attr_reader :app_root, :yaml_loader
end
