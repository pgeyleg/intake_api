# frozen_string_literal: true
require 'rails_helper'

describe ReferralSerializer do
  describe '#as_json' do
    it 'returns the referral base attributes' do
      screening = FactoryGirl.create(:screening)
      as_json = described_class.new(screening).as_json
      expect(as_json).to match a_hash_including(
        response_time: screening.screening_decision_detail,
        additional_information: screening.additional_information,
        assignee: screening.assignee,
        communication_method: screening.communication_method,
        ended_at: screening.ended_at,
        id: screening.id,
        incident_county: screening.incident_county,
        incident_date: screening.incident_date,
        location_type: screening.location_type,
        name: screening.name,
        reference: screening.reference,
        report_narrative: screening.report_narrative,
        screening_decision: screening.screening_decision,
        screening_decision_detail: screening.screening_decision_detail,
        started_at: screening.started_at
      )
    end

    it 'returns the referral address attribues' do
      screening = FactoryGirl.create(:screening, :with_address)
      as_json = described_class.new(screening).as_json
      expect(as_json).to match a_hash_including(
        address: a_hash_including(
          id: screening.address.id,
          city: screening.address.city,
          state: screening.address.state,
          street_address: screening.address.street_address,
          zip: screening.address.zip,
          type: screening.address.type
        )
      )
    end

    it 'returns the referral allegation attributes' do
      victim = FactoryGirl.build(
        :participant,
        roles: ['Victim'],
        screening: nil
      )
      perpetrator = FactoryGirl.build(
        :participant,
        roles: ['Perpetrator'],
        screening: nil
      )
      allegation = FactoryGirl.build(
        :allegation,
        victim: victim,
        perpetrator: perpetrator,
        screening: nil,
        allegation_types: ['General neglect', 'Sexual abuse']
      )
      screening = FactoryGirl.create(
        :screening,
        allegations: [allegation],
        participants: [victim, perpetrator]
      )
      as_json = described_class.new(screening).as_json
      expect(as_json).to match a_hash_including(
        allegations: [{
          victim_person_id: victim.id,
          perpetrator_person_id: perpetrator.id,
          type: 'General neglect',
          county: screening.incident_county
        }, {
          victim_person_id: victim.id,
          perpetrator_person_id: perpetrator.id,
          type: 'Sexual abuse',
          county: screening.incident_county
        }]
      )
    end

    it 'returns the referral cross report attributes' do
      cross_report_one = FactoryGirl.build(:cross_report)
      cross_report_two = FactoryGirl.build(:cross_report)
      screening = FactoryGirl.create(
        :screening,
        cross_reports: [cross_report_one, cross_report_two]
      )
      as_json = described_class.new(screening).as_json
      expect(as_json).to match a_hash_including(
        cross_reports: [{
          agency_type: cross_report_one.agency_type,
          agency_name: cross_report_one.agency_name,
          method: 'Telephone Report', # This field is not currently being captured
          inform_date: '1996-01-01' # This field is not currently being captured
        }, {
          agency_type: cross_report_two.agency_type,
          agency_name: cross_report_two.agency_name,
          method: 'Telephone Report', # This field is not currently being captured
          inform_date: '1996-01-01' # This field is not currently being captured
        }]
      )
    end

    it 'returns the referral participant attributes' do
      participant_one = FactoryGirl.build(:participant, :with_address)
      participant_two = FactoryGirl.build(:participant, :with_phone_number)
      screening = FactoryGirl.create(
        :screening,
        participants: [participant_one, participant_two]
      )
      as_json = described_class.new(screening).as_json(
        include: %w(participants.addresses address participants.phone_numbers)
      )
      expect(as_json).to match a_hash_including(
        participants: array_including(
          a_hash_including(
            id: participant_one.id,
            first_name: participant_one.first_name,
            last_name: participant_one.last_name,
            gender: participant_one.gender,
            ssn: participant_one.ssn,
            date_of_birth: participant_one.date_of_birth,
            addresses: array_including(
              a_hash_including(
                id: participant_one.addresses.first.id,
                city: participant_one.addresses.first.city,
                state: participant_one.addresses.first.state,
                street_address: participant_one.addresses.first.street_address,
                zip: participant_one.addresses.first.zip,
                type: participant_one.addresses.first.type
              )
            ),
            screening_id: screening.id,
            person_id: nil,
            roles: participant_one.roles
          ),
          a_hash_including(
            id: participant_two.id,
            first_name: participant_two.first_name,
            last_name: participant_two.last_name,
            gender: participant_two.gender,
            ssn: participant_two.ssn,
            date_of_birth: participant_two.date_of_birth,
            addresses: [],
            screening_id: screening.id,
            person_id: nil,
            roles: participant_two.roles,
            phone_numbers: array_including(
              a_hash_including(
                id: participant_two.phone_numbers.first.id,
                number: participant_two.phone_numbers.first.number,
                type: participant_two.phone_numbers.first.type
              )
            )
          )
        )
      )
    end
  end
end
