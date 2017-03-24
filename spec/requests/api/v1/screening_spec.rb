# frozen_string_literal: true
require 'rails_helper'

describe 'Screening API' do
  describe 'POST /api/v1/screenings' do
    it 'creates a screening' do
      screening_params = {
        additional_information: 'I have great reasons',
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'sacramento',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        assignee: 'Michael Geary',
        cross_reports_attributes: [
          { agency_type: 'District attorney', agency_name: 'Sacramento Attorney' }
        ]
      }

      post '/api/v1/screenings', params: screening_params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to include(
        incident_county: 'sacramento',
        additional_information: 'I have great reasons',
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        address: include(
          street_address: nil,
          city: nil,
          state: nil,
          zip: nil
        ),
        cross_reports: [
          { agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ],
        assignee: 'Michael Geary'
      )
      expect(body['id']).to_not eq nil
      expect(body[:address][:id]).to_not eq nil
    end
  end

  describe 'GET /api/v1/screenings/:id' do
    it 'returns a JSON representation of the screening' do
      screening = Screening.create!(
        ended_at: '2016-08-03T01:00:00.000Z',
        additional_information: 'I have great reasons',
        incident_county: 'sacramento',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        assignee: 'Michael Bastow'
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
        date_of_birth: Date.today,
        addresses: [
          Address.new(
            street_address: '1840 Broad rd',
            state: 'CA',
            city: 'sacramento',
            zip: '78495',
            type: 'Work'
          )
        ]
      )

      get "/api/v1/screenings/#{screening.id}"

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to match a_hash_including(
        id: screening.id,
        incident_county: 'sacramento',
        ended_at: '2016-08-03T01:00:00.000Z',
        additional_information: 'I have great reasons',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        assignee: 'Michael Bastow',
        address: a_hash_including(
          id: address.address_id,
          street_address: '123 Fake St',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        ),
        participants: array_including(
          a_hash_including(
            id: participant.id,
            person_id: person.id,
            screening_id: screening.id,
            first_name: 'Bart',
            last_name: 'Simpson',
            gender: 'male',
            ssn: '123-23-1234',
            date_of_birth: Date.today.to_s,
            addresses: [
              {
                id: participant.addresses.map(&:id).first,
                street_address: '1840 Broad rd',
                state: 'CA',
                city: 'sacramento',
                zip: '78495',
                type: 'Work'
              }
            ],
            roles: []
          )
        )
      )
    end
  end

  describe 'PUT /api/v1/screenings/:id' do
    it 'updates attributes of a screening' do
      screening = Screening.create!(
        ended_at: '2016-08-03T01:00:00.000Z',
        incident_county: 'sacramento',
        additional_information: 'I have great reasons',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'The Rocky Horror Show',
        reference: '123ABC',
        screening_decision_detail: '3_days',
        screening_decision: 'information_to_child_welfare_services',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Narrative 123 test',
        assignee: 'Natina Grace'
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
      bart = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson'
      )
      lisa = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson'
      )

      updated_params = {
        name: 'Some new name',
        additional_information: 'This is my new, more comprehensive reasoning',
        incident_county: 'mendocino',
        screening_decision_detail: 'immediate',
        screening_decision: 'screen_out',
        report_narrative: 'Updated Narrative',
        assignee: 'Natina Sheridan',
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
      expect(body).to match a_hash_including(
        id: screening.id,
        ended_at: '2016-08-03T01:00:00.000Z',
        additional_information: 'This is my new, more comprehensive reasoning',
        incident_county: 'mendocino',
        incident_date: '2016-08-02',
        location_type: 'Foster Home',
        communication_method: 'Phone',
        name: 'Some new name',
        reference: '123ABC',
        screening_decision_detail: 'immediate',
        screening_decision: 'screen_out',
        started_at: '2016-08-03T01:00:00.000Z',
        report_narrative: 'Updated Narrative',
        assignee: 'Natina Sheridan',
        address: a_hash_including(
          id: address.address_id,
          street_address: '123 Real St',
          city: 'Fake City',
          state: 'CA',
          zip: '10010'
        ),
        participants: array_including(
          a_hash_including(
            id: bart.id,
            first_name: 'Bart',
            last_name: 'Simpson'
          ),
          a_hash_including(
            id: lisa.id,
            first_name: 'Lisa',
            last_name: 'Simpson'
          )
        )
      )
    end
  end

  describe 'GET /api/v1/screenings', elasticsearch: true do
    let!(:little_shop_of_horrors) do
      Screening.create!(
        reference: 'ABCDEF',
        name: 'Little Shop Of Horrors',
        screening_decision_detail: 'immediate',
        screening_decision: 'screen_out'
      )
    end
    let!(:the_shining) do
      Screening.create!(
        reference: 'HIJKLM',
        name: 'The Shining',
        screening_decision_detail: '3_days',
        screening_decision: 'promote_to_referral'
      )
    end
    let!(:it_follows) do
      Screening.create!(
        reference: 'NOPQRS',
        name: 'It Follows',
        screening_decision_detail: '5_days',
        screening_decision: 'promote_to_referral'
      )
    end
    before { ScreeningsRepo.client.indices.flush }

    context 'when params contains response times' do
      it 'returns screenings matching response times' do
        get '/api/v1/screenings', params: { screening_decision_details: %w(immediate 3_days) }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'id' => little_shop_of_horrors.id,
            'name' => 'Little Shop Of Horrors',
            'screening_decision_detail' => 'immediate',
            'screening_decision' => 'screen_out'
          ),
          a_hash_including(
            'id' => the_shining.id,
            'name' => 'The Shining',
            'screening_decision_detail' => '3_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'id' => it_follows.id,
            'name' => 'It Follows',
            'screening_decision_detail' => '5_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
      end
    end

    context 'when params contains screening decisions' do
      it 'returns screenings matching screening decisions' do
        get '/api/v1/screenings', params: { screening_decisions: ['promote_to_referral'] }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'name' => 'It Follows',
            'screening_decision_detail' => '5_days',
            'screening_decision' => 'promote_to_referral'
          ),
          a_hash_including(
            'name' => 'The Shining',
            'screening_decision_detail' => '3_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'screening_decision_detail' => 'immediate',
            'screening_decision' => 'screen_out'
          )
        )
      end
    end

    context 'when params contains both response times and screening decisions' do
      it 'returns screenings matching screening decisions' do
        get '/api/v1/screenings', params: { screening_decision_details: ['3_days'],
                                            screening_decisions: ['promote_to_referral'] }
        assert_response :success
        body = JSON.parse(response.body)
        expect(body).to match array_including(
          a_hash_including(
            'name' => 'The Shining',
            'screening_decision_detail' => '3_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'name' => 'Little Shop Of Horrors',
            'screening_decision_detail' => 'immediate',
            'screening_decision' => 'screen_out'
          ),
          a_hash_including(
            'name' => 'It Follows',
            'screening_decision_detail' => '5_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
      end
    end

    context 'when params contains non matching data' do
      it 'returns no screenings' do
        get '/api/v1/screenings', params: {
          screening_decisions: ['information_to_child_welfare_services']
        }
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
            'screening_decision_detail' => 'immediate',
            'screening_decision' => 'screen_out'
          ),
          a_hash_including(
            'name' => 'It Follows',
            'screening_decision_detail' => '5_days',
            'screening_decision' => 'promote_to_referral'
          ),
          a_hash_including(
            'name' => 'The Shining',
            'screening_decision_detail' => '3_days',
            'screening_decision' => 'promote_to_referral'
          )
        )
      end
    end
  end
end
