# frozen_string_literal: true

require 'rails_helper'

describe 'Screening API', skip_auth: true do
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
        safety_alerts: ['Remote location'],
        safety_information: 'This is a dangerous place',
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
        allegations: [],
        safety_alerts: ['Remote location'],
        safety_information: 'This is a dangerous place'
      )
      expect(body['id']).to_not eq nil
      expect(body[:address][:id]).to_not eq nil
    end
  end

  describe 'GET /api/v1/screenings/:id' do
    it 'returns a JSON representation of the screening' do
      screening = FactoryGirl.create(
        :screening,
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        safety_alerts: ['Remote location'],
        safety_information: 'This is a dangerous place',
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
        incident_county: screening.incident_county,
        ended_at: screening.ended_at.iso8601(3),
        additional_information: screening.additional_information,
        incident_date: screening.incident_date.to_s(:db),
        location_type: screening.location_type,
        communication_method: screening.communication_method,
        name: screening.name,
        reference: screening.reference,
        screening_decision_detail: 'immediate',
        screening_decision: 'information_to_child_welfare_services',
        safety_information: 'This is a dangerous place',
        safety_alerts: array_including('Remote location'),
        started_at: screening.started_at.iso8601(3),
        report_narrative: screening.report_narrative,
        assignee: screening.assignee,
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
      screening = FactoryGirl.create(
        :screening,
        reference: '123ABC',
        screening_decision_detail: '3_days',
        screening_decision: 'information_to_child_welfare_services',
        safety_alerts: ['Remote location'],
        safety_information: 'This is a dangerous place',
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
        safety_alerts: ['Gang alerts', 'Firearms in Home'],
        safety_information: 'I swear this place is bad news',
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
        additional_information: updated_params[:additional_information],
        assignee: updated_params[:assignee],
        communication_method: screening.communication_method,
        ended_at: screening.ended_at.iso8601(3),
        incident_county: updated_params[:incident_county],
        incident_date: screening.incident_date.to_s(:db),
        location_type: screening.location_type,
        name: updated_params[:name],
        reference: '123ABC',
        report_narrative: updated_params[:report_narrative],
        screening_decision: 'screen_out',
        screening_decision_detail: 'immediate',
        started_at: screening.started_at.iso8601(3),
        address: a_hash_including(
          id: address.address_id,
          street_address: '123 Real St',
          city: 'Fake City',
          state: 'CA',
          zip: '10010'
        ),
        safety_alerts: array_including(
          'Gang alerts',
          'Firearms in Home'
        ),
        safety_information: 'I swear this place is bad news',
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
      FactoryGirl.create(
        :screening,
        reference: 'ABCDEF',
        name: 'Little Shop Of Horrors',
        screening_decision_detail: 'immediate',
        screening_decision: 'screen_out'
      )
    end
    let!(:the_shining) do
      FactoryGirl.create(
        :screening,
        reference: 'HIJKLM',
        name: 'The Shining',
        screening_decision_detail: '3_days',
        screening_decision: 'promote_to_referral'
      )
    end
    let!(:it_follows) do
      FactoryGirl.create(
        :screening,
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
        get '/api/v1/screenings', params: { screening_decision_details: %w[immediate 3_days] }
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

  describe 'POST /api/v1/screenings/:id/submit' do
    let(:victim) do
      FactoryGirl.build(
        :participant,
        roles: ['Victim'],
        screening: nil
      )
    end
    let(:perpetrator) do
      FactoryGirl.build(
        :participant,
        addresses: [FactoryGirl.build(:address)],
        roles: ['Perpetrator'],
        screening: nil
      )
    end
    let(:allegation) do
      FactoryGirl.build(
        :allegation,
        victim: victim,
        perpetrator: perpetrator,
        screening: nil,
        allegation_types: ['General neglect']
      )
    end
    let(:cross_report) { FactoryGirl.build(:cross_report) }
    let(:screening) do
      FactoryGirl.create(
        :screening,
        address: FactoryGirl.build(:address, type: nil), # incident address doesnt have type
        screening_decision: 'promote_to_referral',
        screening_decision_detail: '3_days',
        participants: [victim, perpetrator],
        cross_reports: [cross_report],
        allegations: [allegation]
      )
    end
    let(:referral_id) { FFaker::Guid.guid }
    let(:response_body) do
      { legacy_id: referral_id }.to_json
    end

    before do
      allow(ENV).to receive(:fetch).with('SEARCH_URL')
        .and_return('http://referral_api_url')
      stub_request(:post, %r{/api/v1/referrals})
        .and_return(body: response_body, status: 201, headers: { 'Content-Type' => 'json' })
    end

    it 'POSTS the transformed screening to create referral API' do
      post submit_api_v1_screening_path(screening)
      expect(
        a_request(:post, %r{/api/v1/referrals})
        .with(body: hash_including(
          id: screening.id,
          legacy_id: nil,
          legacy_source_table: nil,
          ended_at: screening.ended_at.iso8601(3),
          incident_county: screening.incident_county,
          incident_date: screening.incident_date.to_s(:db),
          location_type: screening.location_type,
          communication_method: screening.communication_method,
          name: screening.name,
          report_narrative: screening.report_narrative,
          reference: screening.reference,
          response_time: screening.screening_decision_detail,
          screening_decision: screening.screening_decision,
          screening_decision_detail: screening.screening_decision_detail,
          started_at: screening.started_at.iso8601(3),
          assignee: screening.assignee,
          additional_information: screening.additional_information,
          address: {
            legacy_id: nil,
            legacy_source_table: nil,
            city: screening.address.city,
            state: screening.address.state,
            street_address: screening.address.street_address,
            zip: screening.address.zip,
            type: 'Other' # incident address doesn't have type
          },
          participants: [{
            id: perpetrator.id,
            legacy_id: nil,
            legacy_source_table: nil,
            first_name: perpetrator.first_name,
            last_name: perpetrator.last_name,
            gender: perpetrator.gender,
            ssn: perpetrator.ssn,
            date_of_birth: perpetrator.date_of_birth.to_s(:db),
            addresses: [{
              city: perpetrator.addresses.first.city,
              state: perpetrator.addresses.first.state,
              street_address: perpetrator.addresses.first.street_address,
              zip: perpetrator.addresses.first.zip,
              type: perpetrator.addresses.first.type
            }],
            screening_id: screening.id,
            person_id: nil,
            roles: perpetrator.roles
          }, {
            id: victim.id,
            legacy_id: nil,
            legacy_source_table: nil,
            first_name: victim.first_name,
            last_name: victim.last_name,
            gender: victim.gender,
            ssn: victim.ssn,
            date_of_birth: victim.date_of_birth.to_s(:db),
            addresses: [],
            screening_id: screening.id,
            person_id: nil,
            roles: victim.roles
          }],
          cross_reports: [{
            agency_type: cross_report.agency_type,
            agency_name: cross_report.agency_name,
            method: 'Telephone Report', # This field is not currently being captured
            inform_date: '1996-01-01' # This field is not currently being captured
          }],
          allegations: [{
            victim_person_id: victim.id,
            perpetrator_person_id: perpetrator.id,
            type: allegation.allegation_types.first,
            county: screening.incident_county
          }]
        ))
      ).to have_been_made
      expect(response.status).to eq(201)
      expect(response.body).to eq({ referral_id: referral_id }.to_json)
    end
  end

  describe 'POST /api/v1/screenings/:id/submit with errors' do
    let(:screening) { FactoryGirl.create(:screening) }

    before do
      allow(ENV).to receive(:fetch).with('SEARCH_URL')
        .and_return('http://referral_api_url')
      stub_request(:post, %r{/api/v1/referrals})
        .and_return(
          body: { message: 'Unable to validate ScreeningToReferral' }.to_json,
          status: 422, headers: { 'Content-Type' => 'json' }
        )
    end

    it 'returns status code and response body' do
      post submit_api_v1_screening_path(screening)
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to eq('Unable to validate ScreeningToReferral')
    end
  end
end
