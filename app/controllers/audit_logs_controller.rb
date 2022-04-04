# frozen_string_literal: true

class AuditLogsController < ApplicationController
  def show
    @audits = Audit.all.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.rss { render xml: audits_rss(@audits).to_xml }
    end
  end

  require 'rss'

  def audits_rss(audits) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    RSS::Maker.make('2.0') do |maker|
      maker.channel.author = 'Swing Out London'
      maker.channel.updated = Audit.maximum(:created_at).iso8601
      maker.channel.link = 'https://www.swingoutlondon.com'
      maker.channel.title = 'Swing Out London Audit Log'
      maker.channel.description = 'Audit Log for Swing Out London'

      audits.each do |audit|
        editor = Editor.build(audit)
        maker.items.new_item do |item|
          item.link = audit_show_link(audit.auditable_type, audit.auditable_id)
          item.title = audit_title(audit)
          item.date = audit.created_at.iso8601
          item.author = editor.name
          item.description = JSON.pretty_generate(audit.as_json)
        end
      end
    end
  end

  def audit_title(audit)
    "#{audit.action} #{audit.auditable_type}(#{audit.auditable_id})"
  end

  def audit_show_link(auditable_type, id)
    {
      'Event' => -> { event_url(Event.find(id)) },
      'Venue' => -> { venue_url(Venue.find(id)) },
      'Organiser' => -> { organiser_url(Organiser.find(id)) }
    }.fetch(auditable_type).call
  end
end
