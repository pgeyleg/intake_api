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
                               zip: '11372',
                               type: 'Placement'
                             ])
      person.phone_numbers.build([
                                   number: '571-897-7458',
                                   type: 'Home'
                                 ])
      serialized_person = PersonSerializer.new(person).as_json
      received_person = described_class.new.serialize(person)
      expect(received_person).to eq(serialized_person)
    end
  end
end
