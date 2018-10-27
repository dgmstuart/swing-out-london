# frozen_string_literal: true

module Rack
  class Attack
    logger = Rails.logger
    ip_blocklist = ENV.fetch('IP_BLOCKLIST', '').split(/,\s*/)
    logger.info 'Rack::Attack Will block the following IPs:'
    ip_blocklist.each { |ip| logger.info ip }

    blocklist('block dodgy IP addresses') do |req|
      ip_blocklist.include? req.ip
    end
  end
end
