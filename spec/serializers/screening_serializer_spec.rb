# frozen_string_literal: true

require 'rails_helper'

describe ScreeningSerializer do
  describe 'as_json' do
    let(:started_at) { Time.parse('2016-11-30T00:00:00.000Z') }
    let(:ended_at) { Time.parse('2016-12-31T00:00:00.000Z') }
    let(:incident_date) { Date.parse('2016-11-30') }
    let(:person) { Person.new }
    let(:cross_report) { FactoryGirl.build(:cross_report) }

    let(:participant) do
      Participant.new(
        person: person,
        first_name: 'Paula',
        last_name: 'Jones',
        gender: 'female',
        ssn: '111223333',
        date_of_birth: Date.parse('2016-01-01'),
        addresses: [
          Address.new(
            street_address: '1840 Broad rd',
            state: 'CA',
            city: 'sacramento',
            zip: '78495',
            type: 'Work'
          )
        ],
        roles: %w[Perpetrator Victim]
      )
    end

    let(:other_participant) { Participant.new }

    let(:screening) do
      Screening.new(
        communication_method: 'email',
        additional_information: 'I have my reasons',
        ended_at: ended_at,
        incident_county: 'alpine',
        incident_date: incident_date,
        location_type: "Child's Home",
        name: 'My Report',
        reference: '1T4THW',
        report_narrative: 'It helps pass the time.',
        screening_decision_detail: '3_days',
        screening_decision: 'promote_to_referral',
        started_at: started_at,
        participants: [participant, other_participant],
        safety_alerts: ['Gang activity'],
        safety_information: 'This is an unsafe location',
        cross_reports: [cross_report],
        assignee: 'Michael Geary'
      )
    end
    let(:allegation) { FactoryGirl.build(:allegation, screening: screening) }

    before do
      screening.build_screening_address
      screening.screening_address.build_address(
        street_address: '52 Evercrest',
        state: 'AL',
        city: 'Albatros',
        zip: '12333',
        type: 'Placement'
      )
      screening.save!

      allegation.perpetrator_id = participant.id
      allegation.victim_id = other_participant.id
      allegation.save!
    end

    it 'returns the attributes of a screening as a hash' do
      expect(described_class.new(screening)
        .as_json(include:
      [
        'participants.addresses',
        'address',
        'cross_reports',
        'allegations'
      ])).to match a_hash_including(
        id: screening.id,
        communication_method: 'email',
        additional_information: 'I have my reasons',
        ended_at: ended_at,
        incident_county: 'alpine',
        incident_date: incident_date,
        location_type: "Child's Home",
        name: 'My Report',
        reference: '1T4THW',
        report_narrative: 'It helps pass the time.',
        screening_decision_detail: '3_days',
        screening_decision: 'promote_to_referral',
        started_at: started_at,
        address: a_hash_including(
          id: screening.address.id,
          street_address: '52 Evercrest',
          state: 'AL',
          city: 'Albatros',
          zip: '12333',
          type: 'Placement'
        ),
        safety_information: 'This is an unsafe location',
        safety_alerts: array_including(
          'Gang activity'
        ),
        cross_reports: array_including(
          a_hash_including(
            agency_type: cross_report.agency_type,
            agency_name: cross_report.agency_name
          )
        ),
        participants: array_including(a_hash_including(
                                        id: participant.id,
                                        person_id: person.id,
                                        screening_id: screening.id,
                                        first_name: 'Paula',
                                        last_name: 'Jones',
                                        gender: 'female',
                                        ssn: '111223333',
                                        date_of_birth: Date.parse('2016-01-01'),
                                        addresses: array_including(
                                          a_hash_including(
                                            id: participant.addresses.map(&:id).first,
                                            street_address: '1840 Broad rd',
                                            state: 'CA',
                                            city: 'sacramento',
                                            zip: '78495',
                                            type: 'Work'
                                          )
                                        ),
                                        roles: %w[Perpetrator Victim]
        ), a_hash_including(
             id: other_participant.id,
             screening_id: screening.id
        )),
        allegations: array_including(a_hash_including(
                                       id: allegation.id,
                                       perpetrator_id: participant.id,
                                       victim_id: other_participant.id
        )),
        assignee: 'Michael Geary'
      )
    end
  end
end
