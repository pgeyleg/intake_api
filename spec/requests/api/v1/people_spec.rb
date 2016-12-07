# frozen_string_literal: true
require 'rails_helper'

describe 'People API' do
  describe 'POST /api/v1/people' do
    before { Timecop.freeze('2016-12-03T22:08:38.204Z') }

    it 'creates a person' do
      person_params = {
        first_name: 'David',
        middle_name: 'Jon',
        last_name: 'Gilmour',
        name_suffix: 'esq',
        gender: 'male',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        address: {
          street_address: '123 fake st',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        },
        phone_numbers: [
          { number: '917-901-8765', type: 'Home' },
          { number: '916-101-1234', type: 'Cell' }
        ],
        languages: %w(
          Hmong
          Japanese
          German
        )
      }
      post '/api/v1/people', params: person_params

      expect(response.status).to eq(201)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to a_hash_including(
        first_name: 'David',
        middle_name: 'Jon',
        last_name: 'Gilmour',
        name_suffix: 'esq',
        gender: 'male',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        address: a_hash_including(
          street_address: '123 fake st',
          state: 'NY',
          city: 'Fake City',
          zip: 10_010
        ),
        phone_numbers: array_including(
          a_hash_including(
            number: '917-901-8765',
            type: 'Home',
            created_at: '2016-12-03T22:08:38.204Z',
            updated_at: '2016-12-03T22:08:38.204Z'
          ),
          a_hash_including(
            number: '916-101-1234',
            type: 'Cell',
            created_at: '2016-12-03T22:08:38.204Z',
            updated_at: '2016-12-03T22:08:38.204Z'
          )
        ),
        languages: array_including(
          'Hmong',
          'Japanese',
          'German'
        )
      )
    end
  end

  describe 'GET /api/v1/people/:id' do
    it 'returns a JSON representation of the person' do
      person = Person.create(first_name: 'Walter', last_name: 'White')

      get "/api/v1/people/#{person.id}"

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['first_name']).to eq('Walter')
      expect(body['last_name']).to eq('White')
      expect(body['phone_numbers']).to eq([])
    end
  end

  describe 'PUT /api/v1/people/:id' do
    let(:person) do
      person = Person.new(
        first_name: 'Walter',
        last_name: 'White',
        languages: %w(Hmong Japanese German)
      )
      person.build_person_address
      person.person_address.build_address
      person.phone_numbers.build(number: '111-111-1111')
      person.phone_numbers.build(number: '222-222-2222')
      person
    end
    let(:existing_phone_number) { person.phone_numbers.first }
    let(:created_at) { '2016-12-03T22:08:38.204Z' }
    let(:updated_at) { '2016-12-03T22:12:38.204Z' }

    before do
      Timecop.freeze(created_at)
      person.save!
      Timecop.freeze(updated_at)
    end

    it 'updates attributes of a person' do
      person_params = {
        first_name: 'Deborah',
        middle_name: 'Ann',
        last_name: 'Harry',
        name_suffix: 'md',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        address: {
          street_address: '123 fake st',
          city: 'Fake City',
          state: 'NY',
          zip: '10010'
        },
        phone_numbers: [{
          id: existing_phone_number.id,
          number: '333-333-3333',
          type: 'Home'
        }, {
          id: nil,
          number: '444-444-4444',
          type: 'Cell'
        }],
        languages: %w(Japanese English)
      }.with_indifferent_access

      put "/api/v1/people/#{person.id}", params: person_params

      expect(response.status).to eq(200)
      body = JSON.parse(response.body).with_indifferent_access
      expect(body).to a_hash_including(
        id: person.id,
        first_name: 'Deborah',
        middle_name: 'Ann',
        last_name: 'Harry',
        name_suffix: 'md',
        gender: 'female',
        date_of_birth: '1990-03-30',
        ssn: '345-12-2345',
        address: a_hash_including(
          street_address: '123 fake st',
          state: 'NY',
          city: 'Fake City',
          zip: 10_010,
          id: person.address.id
        ),
        phone_numbers: array_including(
          a_hash_including(
            id: existing_phone_number.id,
            number: '333-333-3333',
            type: 'Home',
            created_at: created_at,
            updated_at: updated_at,
          ),
          a_hash_including(
            number: '444-444-4444',
            type: 'Cell',
            created_at: updated_at,
            updated_at: updated_at,
          )
        ),
        languages: array_including('Japanese', 'English')
      )
      expect(person.person_phone_numbers.count).to eq 2
      expect(person.phone_numbers.count).to eq 2
    end
  end

  describe 'DELETE /api/v1/people/:id' do
    it 'deletes the person' do
      person = Person.create(first_name: 'Walter', last_name: 'White')

      delete "/api/v1/people/#{person.id}"

      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
  end
end
