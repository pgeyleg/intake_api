# frozen_string_literal: true
require 'rails_helper'

describe ScreeningSerializer do
  describe 'as_json' do
    it 'returns the attributes of a screening as a hash' do
      started_at = Time.parse('2016-11-30T00:00:00.000Z')
      ended_at = Time.parse('2016-12-31T00:00:00.000Z')
      incident_date = Date.parse('2016-11-30')
      person = Person.create
      participant = Participant.new(
        person: person,
        first_name: 'Paula',
        last_name: 'Jones',
        gender: 'female',
        ssn: '111223333',
        date_of_birth: Date.parse('2016-01-01')
      )
      screening = Screening.new(
        communication_method: 'email',
        ended_at: ended_at,
        incident_county: 'alpine',
        incident_date: incident_date,
        location_type: "Child's Home",
        name: 'My Report',
        reference: '1T4THW',
        report_narrative: 'It helps pass the time.',
        response_time: 'within_twenty_four_hours',
        screening_decision: 'accept_for_investigation',
        started_at: started_at
      )
      screening.build_screening_address
      screening.screening_address.build_address(
        street_address: '52 Evercrest',
        state: 'AL',
        city: 'Albatros',
        zip: 12_333
      )
      screening.participants << participant
      screening.save!
      expect(
        described_class.new(screening).as_json
      ).to eq(
        id: screening.id,
        communication_method: 'email',
        created_at: screening.created_at,
        ended_at: ended_at,
        incident_county: 'alpine',
        incident_date: incident_date,
        location_type: "Child's Home",
        name: 'My Report',
        reference: '1T4THW',
        report_narrative: 'It helps pass the time.',
        response_time: 'within_twenty_four_hours',
        screening_decision: 'accept_for_investigation',
        started_at: started_at,
        address: {
          id: screening.address.id,
          street_address: '52 Evercrest',
          state: 'AL',
          city: 'Albatros',
          zip: 12_333
        },
        participants: [{
          id: screening.participant_ids.first,
          person_id: person.id,
          screening_id: screening.id,
          first_name: 'Paula',
          last_name: 'Jones',
          gender: 'female',
          ssn: '111223333',
          date_of_birth: Date.parse('2016-01-01')
        }]
      )
    end
  end
end
