# frozen_string_literal: true
require 'rails_helper'

describe PeopleRepo do
  describe '#serialize' do
    it 'returns the serialized person record' do
      person = Person.new(
        first_name: 'Paul',
        middle_name: 'Maurice',
        last_name: 'Kelly',
        name_suffix: 'Jr',
        gender: 'male',
        ssn: '321021222',
        date_of_birth: Date.parse('1955-01-31'),
        languages: %w(Turkish German),
        races: %w(White Asian)
      )
      person.addresses.build([
                               street_address: '9273 Corona St',
                               state: 'NY',
                               city: 'Jackson Heights',
                               zip: 11_372,
                               type: 'Placement'
                             ])
      serialized_person = PersonSerializer.new(person).as_json.except(:phone_numbers)
      expect(described_class.new.serialize(person)).to eq(serialized_person)
    end
  end
end
