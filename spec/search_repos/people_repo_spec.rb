# frozen_string_literal: true
require 'rails_helper'

describe PeopleRepo do
  describe '#serialize' do
    it 'returns the attributes of the person record' do
      person = double(:person, attributes: 'my attributes')
      serialized_person = described_class.new.serialize(person)
      expect(serialized_person).to include(person.attributes)
    end
  end
end
