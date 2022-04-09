# frozen_string_literal: true

class AuditLogsController < ApplicationController
  before_action :authenticate

  def show
    @audits = Audit.all.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.atom { render xml: audits_rss(@audits).to_xml }
    end
  end

  require 'rss'

  def audits_rss(audits) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    RSS::Maker.make('atom') do |maker|
      maker.channel.author = 'Swing Out London'
      maker.channel.updated = Audit.maximum(:created_at).iso8601
      maker.channel.id = 'https://www.swingoutlondon.com/'
      link = maker.channel.links.new_link
      link.href = 'https://www.swingoutlondon.com/audit_log.atom'
      link.rel = 'self'
      maker.channel.title = 'Swing Out London Audit Log'
      maker.channel.description = 'Audit Log for Swing Out London'

      audits.each do |audit|
        editor = Editor.build(audit)
        auditable = record(audit.auditable_type, audit.auditable_id)
        maker.items.new_item do |item|
          item.link = audit_show_link(auditable)
          item.title = audit_title(audit.action, auditable)
          item.updated = audit.created_at.iso8601
          item.author = editor.name
          item.description = JSON.pretty_generate(audit.as_json)
        end
      end
    end
  end

  def audit_title(action, record)
    "#{action.capitalize} #{record.class}: \"#{auditable_name(record)}\" (id: #{record.id})"
  end

  def record(class_name, id)
    {
      'Event' => -> { Event.find(id) },
      'Venue' => -> { Venue.find(id) },
      'Organiser' => -> { Organiser.find(id) }
    }.fetch(class_name).call
  end

  def auditable_name(record)
    {
      'Event' => -> { record.title },
      'Venue' => -> { record.name },
      'Organiser' => -> { record.name }
    }.fetch(record.class.name).call
  end

  def audit_show_link(record)
    {
      'Event' => -> { event_url(record) },
      'Venue' => -> { venue_url(record) },
      'Organiser' => -> { organiser_url(record) }
    }.fetch(record.class.name).call
  end

  def authenticate
    head :unauthorized unless params[:password] == ENV.fetch('AUDIT_LOG_PASSWORD')
  end
end
