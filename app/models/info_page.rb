# frozen_string_literal: true

class InfoPage
  def initialize(page)
    pages_config = load_config_file("info_pages.yml")
    @page = pages_config.fetch(page)
  end

  def content_partials
    partials(:content)
  end

  def sidebar_partials
    partials(:sidebar)
  end

  private

  def partials(key)
    @page.fetch(CITY.key).fetch(key).map { Partial.new(root, _1) }
  end

  def root
    @page.fetch(:dir_path)
  end

  def load_config_file(filename)
    file_path = Rails.root.join("config", filename)
    YAML.load_file(file_path).deep_symbolize_keys
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
