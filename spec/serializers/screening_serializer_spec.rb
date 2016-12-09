# frozen_string_literal: true
require 'rails_helper'

describe ScreeningSerializer do
  describe 'as_json' do
    let(:started_at) { Time.parse('2016-11-30T00:00:00.000Z') }
    let(:ended_at) { Time.parse('2016-12-31T00:00:00.000Z') }
    let(:incident_date) { Date.parse('2016-11-30') }
    let(:person) { Person.new }
    let(:participant) do
      Participant.new(
        person: person,
        first_name: 'Paula',
        last_name: 'Jones',
        gender: 'female',
        ssn: '111223333',
        date_of_birth: Date.parse('2016-01-01')
      )
    end
    let(:screening) do
      Screening.new(
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
        started_at: started_at,
        participants: [participant]
      )
    end

    before do
      screening.build_screening_address
      screening.screening_address.build_address(
        street_address: '52 Evercrest',
        state: 'AL',
        city: 'Albatros',
        zip: 12_333,
        type: 'Placement'
      )
      screening.save!
    end

    it 'returns the attributes of a screening as a hash' do
      expect(described_class.new(screening).as_json).to eq(
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
          zip: 12_333,
          type: 'Placement'
        },
        participants: [{
          id: participant.id,
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
