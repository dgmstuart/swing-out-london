# frozen_string_literal: true

require 'rails_helper'

describe EventsHelper do
  describe 'school_name' do
    it 'fails if called on a non-class' do
      event = build(:event, has_class: false)
      expect { helper.school_name(event) }.to raise_error(RuntimeError)
    end

    context 'when there is no organiser' do
      it 'returns an empty string' do
        swingclass = build(:class, class_organiser: nil)
        expect(helper.school_name(swingclass)).to be_nil
      end
    end

    context 'when there is a class organiser' do
      it "raises an error if the organiser's name is blank" do
        organiser = build(:organiser, name: nil)
        swingclass = build(:class, class_organiser: organiser)
        expect { helper.school_name(swingclass) }.to raise_error(RuntimeError)
      end

      it "uses the name if the shortname doesn't exist" do
        organiser = build(:organiser, name: 'foo', shortname: nil)
        swingclass = build(:class, class_organiser: organiser)
        expect(helper.school_name(swingclass)).to eq('foo')
      end

      it 'uses the shortname as an abbreviation if it exists' do
        organiser = build(:organiser, name: 'foo', shortname: 'bar')
        swingclass = build(:class, class_organiser: organiser)
        expect(helper.school_name(swingclass)).to eq(%(<abbr title="foo">bar</abbr>))
      end
    end
  end
end
