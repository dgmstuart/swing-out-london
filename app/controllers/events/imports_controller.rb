# frozen_string_literal: true

module Events
  class ImportsController < CMSBaseController
    def new
      @events_import = EventsImport.new
    end

    def create
      csv = params.require('events_import').require('csv')

      import_result = EventsImporter.new.import(csv)

      cachable_result = YAML.dump(import_result)
      Rails.cache.write('latest_import_csv_data', cachable_result)

      @imported_events = import_result.successes.map do |success|
        ImportedDates.new(success)
      end

      @failed_imports = import_result.failures

      render :show
    end

    def save
      cached_result = Rails.cache.fetch('latest_import_csv_data')

      if update_events(cached_result)  # rubocop:disable Style/GuardClause
        redirect_to '/events'
      else
        raise 'No cached result found!!'
      end
    end

    private

    def update_events(imported_data)
      return false unless imported_data

      import_result = YAML.load(imported_data)
      import_result.successes.each do |success|
        event = Event.find(success.event_id)
        event.date_array = success.dates_to_import.join(', ')
        event.save!
      end

      true
    end
  end
end
