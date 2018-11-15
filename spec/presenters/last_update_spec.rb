# frozen_string_literal: true

require 'spec_helper'
require 'spec/support/time_formats_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/time/zones.rb'
require 'app/presenters/last_update'

RSpec.describe LastUpdate do
  describe '#name' do
    it 'is the name of the editor on the last audit record' do
      audit = instance_double('Audited::Audit')
      audits = [double, double, audit]
      resource = instance_double('Venue', audits: audits)
      editor = instance_double('Editor::RealEditor', name: 'Ann Johnson')
      editor_builder = class_double('Editor')
      allow(editor_builder).to receive(:build).with(audit).and_return(editor)

      update = described_class.new(resource, editor_builder: editor_builder)

      expect(update.name).to eq 'Ann Johnson'
    end
  end

  describe '#auth_id' do
    it 'is the id of the editor on the last audit record' do
      audit = instance_double('Audited::Audit')
      audits = [double, double, audit]
      resource = instance_double('Venue', audits: audits)
      editor = instance_double('Editor::RealEditor', auth_id: 98421080901168127)
      editor_builder = class_double('Editor')
      allow(editor_builder).to receive(:build).with(audit).and_return(editor)

      update = described_class.new(resource, editor_builder: editor_builder)

      expect(update.auth_id).to eq 98421080901168127
    end
  end

  describe '#time_in_words' do
    it 'is the time of the last update in words' do
      updated_at = Time.utc(1926, 3, 12, 12, 1, 0).in_time_zone('London')
      resource = instance_double('Venue', updated_at: updated_at)
      editor_builder = class_double('Editor')

      update = described_class.new(resource, editor_builder: editor_builder)

      expect(update.time_in_words).to eq 'on Friday 12th March 1926 at 12:01:00'
    end
  end
end
