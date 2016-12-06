# frozen_string_literal: true
require 'rails_helper'

describe PersonSerializer do
  describe 'as_json' do
    it 'returns the attributes of a person as a hash' do
      person = Person.new(
        first_name: 'Paul',
        middle_name: 'Maurice',
        last_name: 'Kelly',
        name_suffix: 'Jr',
        gender: 'male',
        ssn: '321021222',
        date_of_birth: Date.parse('1955-01-31')
      )
      person.build_person_address
      person.person_address.build_address(
        street_address: '9273 Corona St',
        state: 'NY',
        city: 'Jackson Heights',
        zip: 11_372
      )
      person.save!
      expect(
        described_class.new(person).as_json
      ).to eq(
        id: person.id,
        date_of_birth: Date.parse('1955-01-31'),
        first_name: 'Paul',
        gender: 'male',
        last_name: 'Kelly',
        middle_name: 'Maurice',
        name_suffix: 'Jr',
        ssn: '321021222',
        address: {
          id: person.address.id,
          street_address: '9273 Corona St',
          state: 'NY',
          city: 'Jackson Heights',
          zip: 11_372
        }
      )
    end
  end
end
