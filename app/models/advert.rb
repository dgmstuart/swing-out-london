# frozen_string_literal: true

class Advert
  def self.current(env: ENV)
    return unless env['ADVERT_ENABLED'] == 'true'

    new(
      url: env.fetch('ADVERT_URL'),
      image_url: env.fetch('ADVERT_IMAGE_URL'),
      title: env.fetch('ADVERT_TITLE'),
      google_id: env.fetch('ADVERT_GOOGLE_ID')
    )
  end

  def initialize(url:, image_url:, title:, google_id:)
    @url = url
    @image_url = image_url
    @title = title
    @google_id = google_id
  end

  attr_reader :url, :image_url, :title, :google_id
end
