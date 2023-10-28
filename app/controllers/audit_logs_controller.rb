# frozen_string_literal: true

class AuditLogsController < ApplicationController
  before_action :authenticate
  include CityHelper

  def show
    @audits = Audit.order(created_at: :desc)
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
        auditable = record(audit.auditable_type, audit.auditable_id)
        maker.items.new_item do |item|
          item.link = audit_show_link(auditable)
          item.id = "#{audit_show_link(auditable)}?action=#{audit.action}&updated_at=#{audit.created_at.to_i}"
          item.title = audit_title(audit.action, auditable)
          item.updated = audit.created_at.iso8601
          item.author = editor.name
          item.description = JSON.pretty_generate(audit.as_json)
        end
      end
    end
  end

  def audit_title(action, record)
    if action == "destroy"
      "Delete #{record.class} (id: #{record.id})"
    else
      "#{action.capitalize} #{auditable_name(record)} (id: #{record.id})"
    end
  end

  def record(class_name, id)
    {
      "Event" => -> { Event.find_by(id:) || Event.new(id:) },
      "Venue" => -> { Venue.find_by(id:) || Venue.new(id:) },
      "Organiser" => -> { Organiser.find_by(id:) || Organiser.new(id:) }
    }.fetch(class_name).call
  end

  def auditable_name(record)
    {
      "Event" => -> { auditable_event_name(record) },
      "Venue" => -> { "Venue: \"#{record.name}\"" },
      "Organiser" => -> { "Organiser: \"#{record.name}\"" }
    }.fetch(record.class.name).call
  end

  def auditable_event_name(record)
    if record.title.blank? && record.has_class? && !record.has_social?
      "Class"
    else
      "Event: \"#{record.title}\""
    end
  end

  def audit_show_link(record)
    {
      "Event" => -> { event_url(record) },
      "Venue" => -> { venue_url(record) },
      "Organiser" => -> { organiser_url(record) }
    }.fetch(record.class.name).call
  end

  def authenticate
    head :unauthorized unless params[:password] == ENV.fetch("AUDIT_LOG_PASSWORD")
  end
end
