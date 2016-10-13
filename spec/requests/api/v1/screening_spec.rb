# frozen_string_literal: true
require 'rails_helper'

describe 'Screening API' do
  describe 'POST /api/v1/screenings' do
    it 'creates a screening' do
      screening_params = {
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'sacramento',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        response_time: 'immediate',
        screening_decision: 'referral_to_other_agency',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test'
      }

      post '/api/v1/screenings', params: screening_params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        incident_county: 'sacramento',
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        response_time: 'immediate',
        screening_decision: 'referral_to_other_agency',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        address: include(
          street_address: nil,
          city: nil,
          state: nil,
          zip: nil
        )
      )
      expect(body['id']).to_not eq nil
    end
  end

  describe 'GET /api/v1/screenings/:id' do
    it 'returns a JSON representation of the screening' do
      screening = Screening.create(
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'sacramento',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        response_time: 'immediate',
        screening_decision: 'referral_to_other_agency',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test'
      )

      address = ScreeningAddress.create(
        screening: screening,
        address: Address.create(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )

      screening_person = ScreeningPerson.create(
        screening: screening,
        person: Person.create(
          first_name: 'Bart',
          last_name: 'Simpson',
          gender: 'male',
          ssn: '123-23-1234',
          date_of_birth: Date.today
        )
      )

      get "/api/v1/screenings/#{screening.id}"

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        id: screening.id,
        incident_county: 'sacramento',
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        response_time: 'immediate',
        screening_decision: 'referral_to_other_agency',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        address: include(
          id: address.address_id,
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: 10_010
        ),
        participants: include(
          id: screening_person.person.id,
          first_name: 'Bart',
          last_name: 'Simpson',
          gender: 'male',
          ssn: '123-23-1234',
          date_of_birth: Date.today.to_s
        )
      )
    end
  end

  describe 'PUT /api/v1/screenings/:id' do
    it 'updates attributes of a screening' do
      screening = Screening.create(
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'sacramento',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        response_time: 'within_twenty_four_hours',
        screening_decision: 'referral_to_other_agency',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test'
      )
      address = ScreeningAddress.create(
        screening: screening,
        address: Address.create(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )
      bart = Person.create(first_name: 'Bart', last_name: 'Simpson')
      lisa = Person.create(first_name: 'Lisa', last_name: 'Simpson')

      updated_params = {
        name: 'Some new name',
        incident_county: 'mendocino',
        response_time: 'immediate',
        screening_decision: 'evaluate_out',
        report_narrative: 'Updated Narrative',
        address: {
          id: address.address_id,
          street_address: '123 Real St',
          city: 'Fake City',
          state: 'CA',
          zip: '10010'
        },
        participant_ids: [bart.id, lisa.id]
      }

      expect do
        put "/api/v1/screenings/#{screening.id}", params: updated_params
      end.to change(Address, :count).by(0)

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        id: screening.id,
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'mendocino',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'Some new name',
        reference: '123ABC',
        response_time: 'immediate',
        screening_decision: 'evaluate_out',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Updated Narrative',
        address: include(
          id: address.address_id,
          street_address: '123 Real St',
          city: 'Fake City',
          state: 'CA',
          zip: 10_010
        ),
        participants: [
          include(
            first_name: 'Bart',
            last_name: 'Simpson'
          ),
          include(
            first_name: 'Lisa',
            last_name: 'Simpson'
          )
        ]
      )
    end
  end
end
