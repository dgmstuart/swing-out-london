# frozen_string_literal: true

class AuditLogsController < ApplicationController
  before_action :authenticate
  include CityHelper

  def show
    @audits = AuditLogEntry.all
    respond_to do |format|
      format.atom { render xml: audits_rss(@audits).to_xml }
    end
  end

  require "rss"

  def audits_rss(audits) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    RSS::Maker.make("atom") do |maker|
      maker.channel.author = tc("site_name")
      maker.channel.updated = Audit.maximum(:created_at).iso8601
      maker.channel.id = tc("site_url")
      link = maker.channel.links.new_link
      link.href = URI.join(tc("site_url"), "/audit_log.atom").to_s
      link.rel = "self"
      maker.channel.title = "#{tc('site_name')} Audit Log"
      maker.channel.description = "Audit Log for #{tc('site_name')}"

      audits.each do |audit|
        editor = Editor.build(audit)
        maker.items.new_item do |item|
          item.link = audit_show_link(audit)
          item.id = "#{audit_show_link(audit)}?action=#{audit.action}&updated_at=#{audit.created_at.to_i}"
          item.title = "#{audit.action.capitalize} #{audit.auditable_name} (id: #{audit.auditable_id})"
          item.updated = audit.created_at.iso8601
          item.author = editor.name
          item.description = JSON.pretty_generate(audit.as_json)
        end
      end
    end
  end

  def audit_show_link(audit)
    {
      "Event" => -> { event_url(audit.auditable_id) },
      "Venue" => -> { venue_url(audit.auditable_id) },
      "Organiser" => -> { organiser_url(audit.auditable_id) }
    }.fetch(audit.auditable_type).call
  end

  def authenticate
    head :unauthorized unless params[:password] == ENV.fetch("AUDIT_LOG_PASSWORD")
  end
end
