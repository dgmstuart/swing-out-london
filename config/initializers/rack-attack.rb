# frozen_string_literal: true

class DodgyIPs
  attr_reader :ip_list

  def initialize
    @ip_list = dodgy_ips_variable.split(/,\s*/)
  end

  private

  def dodgy_ips_variable
    ENV['IP_BLOCKLIST'] || raise('IP_BLOCKLIST was nil')
  end
end

class Rack::Attack
  dodgy_ips = DodgyIPs.new.ip_list
  puts 'Rack::Attack Will block the following IPs:'
  dodgy_ips.each { |ip| puts ip }

  blocklist('block dodgy IP addresses') do |req|
    dodgy_ips.include? req.ip
  end
end
