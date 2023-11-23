# frozen_string_literal: true

# Log the IP addresses which we're logging
logger = Rails.logger
ip_blocklist = ENV.fetch("IP_BLOCKLIST", "").split(/,\s*/)
logger.info "Rack::Attack Will block the following IPs:"
ip_blocklist.each { |ip| logger.info ip }

Rack::Attack.blocklist("block dodgy IP addresses") do |request|
  ip_blocklist.include? request.ip
end

WORDPRESS_PATHS = %w[wp-login wp-admin wp-includes wp-content xmlrpc.php wordpress].freeze
OTHER_PROGRAMMING_LANGUAGES = %w[.php .asp].freeze
MALWARE_PATHS = %w[alfacgiapi ALFA_DATA cgialfa].freeze
SUSPICIOUS_PATHS = WORDPRESS_PATHS + OTHER_PROGRAMMING_LANGUAGES + MALWARE_PATHS
# If we receive 3 requests which look like attempted hacks, in the span of 10 mins, ban that IP for 15 mins
Rack::Attack.blocklist("Block suspicious requests") do |request|
  Rack::Attack::Fail2Ban.filter("suspicious-#{request.ip}", maxretry: 3, findtime: 10.minutes, bantime: 15.minutes) do
    SUSPICIOUS_PATHS.any? { |path| request.path.include?(path) }
  end
end

# Limit requests to 5 per ip every 2 seconds
Rack::Attack.throttle("req/ip", limit: 5, period: 2) do |request| # rubocop:disable Style/SymbolProc
  request.ip
end
