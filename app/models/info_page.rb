# frozen_string_literal: true

class InfoPage
  def initialize(page_name, pages: InfoPages.new, city: CITY.key)
    @page = pages.page(page_name)
    @city = city
  end

  def content_partials
    partials(:content)
  end

  def sidebar_partials
    partials(:sidebar)
  end

  private

  def partials(key)
    @page.fetch(@city).fetch(key).map { Partial.new(root, _1) }
  end

  def root
    @page.fetch(:dir_path)
  end

  class InfoPages
    def initialize(config: Config.new.load("info_pages.yml"))
      @config = config
    end

    def page(page_name)
      @config.fetch(page_name)
    end
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
