# frozen_string_literal: true
require 'rails_helper'

describe 'Screening API' do
  describe 'POST /api/v1/screenings' do
    context 'remote authentication is enabled' do
      let(:auth_url) { 'http://test.com' }
      let(:auth_token) { 'fake_token' }
      let(:http_status) { 200 }
      let(:headers) { { 'Authorization' => auth_token } }

      before do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with('AUTHENTICATION_URL').and_return(auth_url)
        allow(ENV).to receive(:fetch).with('AUTHENTICATION', false).and_return(true)
        faraday_double = double :faraday, status: http_status
        allow(Faraday).to receive(:get)
          .with("#{auth_url}/authn/validate?token=#{auth_token}")
          .and_return faraday_double
      end

      it 'gets part of the url from the environment variable' do
        expect(ENV).to receive(:fetch).with('AUTHENTICATION_URL').and_return(auth_url)
        get '/api/v1/screenings', headers: headers
      end

      context 'with a valid token' do
        let(:http_status) { 200 }

        it 'responds with a 200 status' do
          get '/api/v1/screenings', headers: headers
          expect(response.status).to eq 200
        end

        it 'hits correct action' do
          expect_any_instance_of(Api::V1::ScreeningsController).to receive(:index)
          get '/api/v1/screenings', headers: headers
        end
      end

      context 'token is invalid' do
        let(:http_status) { 403 }

        it 'responds with a 403' do
          get '/api/v1/screenings', headers: headers
          expect(response.status).to eq 403
        end

        it 'responds with the correct message' do
          get '/api/v1/screenings', headers: headers
          expect(response.body).to eq({ errors: ['Forbidden, request not authorized'] }.to_json)
        end
      end

      context 'other errors' do
        let(:http_status) { 403 }

        it 'responds with 403 for any non-200 response' do
          get '/api/v1/screenings', headers: headers
          expect(response.status).to eq 403
        end
      end
    end

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
        cross_reports: [
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
          {
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ],
        assignee: 'Michael Geary',
        allegations: []
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
        assignee: 'Michael Bastow',
        cross_reports_attributes: [
          {
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ]
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

      person_bart = Person.create!(first_name: 'Bart', last_name: 'Simpson')
      participant_bart = Participant.create!(
        person: person_bart,
        screening: screening,
        first_name: 'Bart',
        last_name: 'Simpson',
        gender: 'male',
        ssn: '123-23-1234',
        date_of_birth: Date.today,
        roles: ['Victim'],
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

      person_homer = Person.create!(first_name: 'Homer', last_name: 'Simpson')
      participant_homer = Participant.create!(
        person: person_homer,
        screening: screening,
        first_name: 'Homer',
        last_name: 'Simpson',
        gender: 'male',
        ssn: '123-45-6789',
        date_of_birth: 20.years.ago.to_date,
        roles: ['Perpetrator']
      )

      allegation = FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: participant_homer.id,
        victim_id: participant_bart.id)

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
        allegations: array_including(
          a_hash_including(
            id: allegation.id,
            screening_id: screening.id,
            perpetrator_id: participant_homer.id,
            victim_id: participant_bart.id
          )
        ),
        participants: array_including(
          a_hash_including(
            id: participant_homer.id,
            person_id: person_homer.id,
            screening_id: screening.id,
            first_name: 'Homer',
            last_name: 'Simpson',
            gender: 'male',
            ssn: '123-45-6789',
            date_of_birth: 20.years.ago.to_date.to_s,
            roles: ['Perpetrator']
          ),
          a_hash_including(
            id: participant_bart.id,
            person_id: person_bart.id,
            screening_id: screening.id,
            first_name: 'Bart',
            last_name: 'Simpson',
            gender: 'male',
            ssn: '123-23-1234',
            date_of_birth: Date.today.to_s,
            addresses: [
              {
                id: participant_bart.addresses.map(&:id).first,
                street_address: '1840 Broad rd',
                state: 'CA',
                city: 'sacramento',
                zip: '78495',
                type: 'Work'
              }
            ],
            roles: ['Victim']
          )
        ),
        cross_reports: [
          {
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ]
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
        assignee: 'Natina Grace',
        cross_reports_attributes: [
          {
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ]
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
        last_name: 'Simpson',
        roles: ['Victim']
      )
      lisa = Participant.create!(
        person: Person.create!,
        screening: screening,
        first_name: 'Lisa',
        last_name: 'Simpson',
        roles: ['Perpetrator']
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
        },
        cross_reports: [
          {
            agency_type: 'Law enforcement',
            agency_name: 'Sacramento Sheriff'
          },
          {
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          }
        ]
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
        cross_reports: array_including(
          a_hash_including(
            agency_type: 'Law enforcement',
            agency_name: 'Sacramento Sheriff'
          ),
          a_hash_including(
            agency_type: 'District attorney',
            agency_name: 'Sacramento Attorney'
          )
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
        ), allegations: []
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

    it 'returns 100 records' do
      expect(ScreeningsRepo).to receive(:search).with(anything, size: 100).and_call_original
      get '/api/v1/screenings', params: {}
    end

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
