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
      screening = Screening.create!(
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

      address = ScreeningAddress.create!(
        screening: screening,
        address: Address.create!(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )

      person = Person.create!(first_name: 'Bart', last_name: 'Simpson')
      participant = Participant.create!(
        person: person,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson',
        gender: 'male',
        ssn: '123-23-1234',
        date_of_birth: Date.today
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
        report_narrative: 'Narrative 123 test'
      )
      expect(body[:address]).to include(
        id: address.address_id,
        street_address: '123 Fake St',
        city: 'Fake City',
        state: 'NY',
        zip: '10010'
      )
      expect(body[:participants]).to include(
        id: participant.id,
        person_id: person.id,
        screening_id: screening.id,
        first_name: 'Bart',
        last_name: 'Simpson',
        gender: 'male',
        ssn: '123-23-1234',
        date_of_birth: Date.today.to_s
      )
    end
  end

  describe 'PUT /api/v1/screenings/:id' do
    it 'updates attributes of a screening' do
      screening = Screening.create!(
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
      address = ScreeningAddress.create!(
        screening: screening,
        address: Address.create!(
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        )
      )
      Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson'
      )
      Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson'
      )

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
        }
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
          zip: '10010'
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

  describe 'GET /api/v1/screenings', elasticsearch: true do
    before do
      Screening.create([{
                         reference: 'ABCDEF',
                         created_at: '2016-08-11T18:24:22.157Z',
                         name: 'Little Shop Of Horrors',
                         response_time: 'immediate',
                         screening_decision: 'evaluate_out'
                       }, {
                         reference: 'HIJKLM',
                         created_at: '2016-07-07T11:21:22.007Z',
                         name: 'The Shining',
                         response_time: 'within_twenty_four_hours',
                         screening_decision: 'accept_for_investigation'
                       }, {
                         reference: 'NOPQRS',
                         created_at: '2016-08-10T09:11:22.112Z',
                         name: 'It Follows',
                         response_time: 'more_than_twenty_four_hours',
                         screening_decision: 'accept_for_investigation'
                       }])
      ScreeningsRepo.client.indices.flush
    end

    context 'when params contains response times' do
      it 'returns screenings matching response times' do
        get '/api/v1/screenings', params: { response_times: %w(immediate within_twenty_four_hours) }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'response_time' => 'immediate',
            'screening_decision' => 'evaluate_out'
          ),
          a_hash_including(
            'name' => 'The Shining',
            'response_time' => 'within_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'name' => 'It Follows',
            'response_time' => 'more_than_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
      end
    end

    context 'when params contains screening decisions' do
      it 'returns screenings matching screening decisions' do
        get '/api/v1/screenings', params: { screening_decisions: ['accept_for_investigation'] }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'name' => 'It Follows',
            'response_time' => 'more_than_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          ),
          a_hash_including(
            'name' => 'The Shining',
            'response_time' => 'within_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'response_time' => 'immediate',
            'screening_decision' => 'evaluate_out'
          )
        )
      end
    end

    context 'when params contains both response times and screening decisions' do
      it 'returns screenings matching screening decisions' do
        get '/api/v1/screenings', params: { response_times: ['within_twenty_four_hours'],
                                            screening_decisions: ['accept_for_investigation'] }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'name' => 'The Shining',
            'response_time' => 'within_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'response_time' => 'immediate',
            'screening_decision' => 'evaluate_out'
          ),
          a_hash_including(
            'name' => 'It Follows',
            'response_time' => 'more_than_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
      end
    end

    context 'when params contains non matching data' do
      it 'returns no screenings' do
        get '/api/v1/screenings', params: { screening_decisions: ['referral_to_other_agency'] }
        assert_response :success
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when neither response times nor screening decisions as passed in' do
      it 'returns all screenings' do
        get '/api/v1/screenings', params: {}
        assert_response :success
        expect(JSON.parse(response.body)).to match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'response_time' => 'immediate',
            'screening_decision' => 'evaluate_out'
          ),
          a_hash_including(
            'name' => 'It Follows',
            'response_time' => 'more_than_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          ),
          a_hash_including(
            'name' => 'The Shining',
            'response_time' => 'within_twenty_four_hours',
            'screening_decision' => 'accept_for_investigation'
          )
        )
      end
    end
  end
end
