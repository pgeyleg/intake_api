# frozen_string_literal: true
require 'rails_helper'

describe PersonSerializer do
  describe 'as_json' do
    let(:person) do
      person = Person.new(
        first_name: 'Paul',
        middle_name: 'Maurice',
        last_name: 'Kelly',
        name_suffix: 'Jr',
        gender: 'male',
        ssn: '321021222',
        date_of_birth: Date.parse('1955-01-31'),
        languages: %w(Turkish German)
      )
      person.addresses.build([
                               street_address: '9273 Corona St',
                               state: 'NY',
                               city: 'Jackson Heights',
                               zip: '11372',
                               type: 'Placement'
                             ])
      person
    end

    before { person.save! }

    it 'returns the attributes of a person as a hash' do
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
        languages: %w(Turkish German),
        phone_numbers: [],
        addresses: [{
          id: person.addresses.map(&:id).first,
          street_address: '9273 Corona St',
          state: 'NY',
          city: 'Jackson Heights',
          zip: '11372',
          type: 'Placement'
        }]
      )
    end
  end
end
