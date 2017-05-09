# frozen_string_literal: true

require 'rails_helper'

describe ReferralParticipantSerializer do
  describe 'as_json' do
    let(:participant) do
      FactoryGirl.create(
        :participant,
        :with_address,
        person: FactoryGirl.build(:person),
        roles: ['Victim']
      )
    end

    it 'returns the attributes of a participant as a hash' do
      expect(described_class.new(participant).as_json).to eq(
        id: participant.id,
        first_name: participant.first_name,
        last_name: participant.last_name,
        gender: participant.gender,
        ssn: participant.ssn,
        date_of_birth: participant.date_of_birth,
        person_id: participant.person_id,
        screening_id: participant.screening_id,
        addresses: [
          {
            street_address: participant.addresses.first.street_address,
            state: participant.addresses.first.state,
            city: participant.addresses.first.city,
            zip: participant.addresses.first.zip,
            type: participant.addresses.first.type
          }
        ],
        roles: participant.roles
      )
    end
  end
end
