# frozen_string_literal: true

# Log the IP addresses which we're logging
logger = Rails.logger
ip_blocklist = ENV.fetch("IP_BLOCKLIST", "").split(/,\s*/)
logger.info "Rack::Attack Will block the following IPs:"
ip_blocklist.each { |ip| logger.info ip }

Rack::Attack.blocklist("block dodgy IP addresses") do |request|
  ip_blocklist.include? request.ip
end
