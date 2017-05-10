# frozen_string_literal: true

require 'rails_helper'

describe ParticipantSerializer do
  describe 'as_json' do
    let(:person) { Person.create }
    let(:screening) { Screening.create }
    let(:participant) do
      Participant.new(
        first_name: 'Robert',
        middle_name: 'Wadsworth',
        last_name: 'Smith',
        name_suffix: 'PhD',
        gender: 'male',
        languages: %w[Turkish German],
        ssn: '111223333',
        date_of_birth: Date.parse('1955-01-31'),
        person: person,
        screening: screening,
        roles: ['Victim']
      )
    end

    before do
      participant.addresses.build(
        street_address: '1840 Broad rd',
        state: 'CA',
        city: 'sacramento',
        zip: '78495',
        type: 'Work'
      )
      participant.phone_numbers.build(
        number: '1234567891',
        type: 'Work'
      )
      participant.save!
    end

    it 'returns the attributes of a participant as a hash' do
      expect(described_class.new(participant).as_json).to eq(
        id: participant.id,
        first_name: 'Robert',
        middle_name: 'Wadsworth',
        last_name: 'Smith',
        name_suffix: 'PhD',
        gender: 'male',
        languages: %w[Turkish German],
        ssn: '111223333',
        date_of_birth: Date.parse('1955-01-31'),
        person_id: person.id,
        screening_id: screening.id,
        addresses: [
          {
            id: participant.addresses.first.id,
            street_address: '1840 Broad rd',
            state: 'CA',
            city: 'sacramento',
            zip: '78495',
            type: 'Work'
          }
        ],
        phone_numbers: [
          {
            id: participant.phone_numbers.first.id,
            number: '1234567891',
            type: 'Work'
          }
        ],
        roles: ['Victim']
      )
    end
  end
end
