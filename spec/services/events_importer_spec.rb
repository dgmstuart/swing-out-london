# frozen_string_literal: true

require 'spec_helper'
require 'app/services/events_importer'

RSpec.describe EventsImporter do
  describe 'import' do
    it 'takes a CSV and returns the names of the relevant events' do
      csv = "www.wibble.com/silentbleep,bollocks\nwww.frank.com/beefheart,morebollocks"

      resource_klass = class_double('Event')
      silentbleep = instance_double('Event', id: 1, title: 'Silent Bleep', url: 'www.wibble.com/silentbleep')
      allow(resource_klass).to receive(:find_by).with(url: 'www.wibble.com/silentbleep').and_return(silentbleep)
      beefheart = instance_double('Event', id: 2, title: 'Beefheart', url: 'www.frank.com/beefheart')
      allow(resource_klass).to receive(:find_by).with(url: 'www.frank.com/beefheart').and_return(beefheart)

      result = described_class.new(resource_klass).import(csv)

      expect(result.successes.length).to eq 2
      expect(result.successes[0].name).to eq 'Silent Bleep'
      expect(result.successes[1].name).to eq 'Beefheart'
    end

    it 'takes a CSV and returns the dates of the relevant events' do
      csv = 'www.wibble.com/silentbleep,"23/12/2012, 30/12/2012"'

      resource_klass = class_double('Event')
      silentbleep = instance_double('Event', id: 3, title: 'Silent Bleep', url: 'www.wibble.com/silentbleep')
      allow(resource_klass).to receive(:find_by).with(url: 'www.wibble.com/silentbleep').and_return(silentbleep)

      result = described_class.new(resource_klass).import(csv)

      expect(result.successes.length).to eq 1
      expect(result.successes.first.dates_to_import).to eq ['23/12/2012', '30/12/2012']
    end

    it 'handles non-matching urls' do
      csv = 'www.wibble.com/silentbleep,"23/12/2012, 30/12/2012"'

      resource_klass = class_double('Event')
      allow(resource_klass).to receive(:find_by).with(url: 'www.wibble.com/silentbleep').and_return(nil)

      result = described_class.new(resource_klass).import(csv)

      expect(result.successes.length).to eq 0
      expect(result.failures.length).to eq 1
      expect(result.failures.first.url).to eq 'www.wibble.com/silentbleep'
      expect(result.failures.first.dates).to eq '23/12/2012, 30/12/2012'
      expect(result.failures.first.reason).to eq 'Url not found'
    end
  end
end
