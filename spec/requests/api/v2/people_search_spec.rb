# frozen_string_literal: true

require 'rails_helper'

describe 'People Search API', skip_auth: true do
  describe 'GET /api/v2/people_search' do
    let(:auth_token) { FFaker::Guid.guid }

    around do |example|
      config = Rails.configuration.intake_api
      Rails.configuration.intake_api[:people_search_path] = '/people_search_path'
      example.run
      Rails.configuration.intake_api = config
    end

    it 'passes the Authorization header to people search API' do
      response_body = { hits: { hits: [] } }.to_json
      stub_request(:post, %r{/people_search_path})
        .and_return(body: response_body, headers: { 'Content-Type' => 'json' })

      get api_v2_people_search_index_path(search_term: 'Test'),
        headers: { Authorization: auth_token }
      expect(
        a_request(:post, %r{/people_search_path})
        .with(headers: { Authorization: auth_token })
      ).to have_been_made
    end

    it 'returns empty array in case of no match' do
      db_results =
        {
          took: 1,
          timed_out: false,
          _shards: {
            total: 5,
            successful: 5,
            failed: 0
          },
          hits: {
            total: 0,
            max_score: nil,
            hits: []
          }
      }
      db_response = double(:response, body: db_results)

      expect(API).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'returns an array of people' do
      db_results = {
        took: 2,
        timed_out: false,
        _shards: {
          total: 5,
          successful: 5,
          failed: 0
        },
        hits: {
          total: 2,
          max_score: 1,
          hits: [
            {
              _index: 'people_drs',
              _type: 'person',
              _id: 'I1dyXvW00b',
              _score: 1,
              _source: {
                phone_numbers: [],
                addresses: [],
                gender: 'male',
                languages: [],
                name_suffix: nil,
                date_of_birth: '1988-03-07',
                last_name: 'Hill',
                id: 'I1dyXvW00b',
                middle_name: '',
                first_name: 'Harold',
                ssn: ''
              },
              highlight: { 'last_name': ['<em>Hill</em>'] }
            },
            {
              _index: 'people_drs',
              _type: 'person',
              _id: 'KKN1s2b75C',
              _score: 1,
              _source: {
                phone_numbers: [],
                addresses: [],
                gender: 'female',
                languages: ['Hawaiian'],
                name_suffix: nil,
                date_of_birth: '1990-03-03',
                last_name: 'Hill',
                id: 'KKN1s2b75C',
                middle_name: '',
                first_name: 'Jane',
                ssn: ''
              },
              highlight: { last_name: ['<em>Hill</em>'] }
            }
          ]
        }
      }
      db_response = double(:response, body: db_results)

      expect(API).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to match array_including(
        {
          'phone_numbers' => [],
          'addresses' => [],
          'gender' => 'male',
          'languages' => [],
          'name_suffix' => nil,
          'date_of_birth' => '1988-03-07',
          'last_name' => 'Hill',
          'id' => 'I1dyXvW00b',
          'middle_name' => '',
          'first_name' => 'Harold',
          'ssn' => '',
          'highlight' => { 'last_name' => '<em>Hill</em>' }
        },
        'phone_numbers' => [],
        'addresses' => [],
        'gender' => 'female',
        'languages' => ['Hawaiian'],
        'name_suffix' => nil,
        'date_of_birth' => '1990-03-03',
        'last_name' => 'Hill',
        'id' => 'KKN1s2b75C',
        'middle_name' => '',
        'first_name' => 'Jane',
        'ssn' => '',
        'highlight' => { 'last_name' => '<em>Hill</em>' }
      )
    end

    it 'includes highlighting' do
      db_results = {
        took: 2,
        timed_out: false,
        _shards: {
          total: 5,
          successful: 5,
          failed: 0
        },
        hits: {
          total: 4,
          max_score: 1,
          hits: [
            {
              _index: 'people_drs',
              _type: 'person',
              _id: 'I1dyXvW00b',
              _score: 1,
              _source: {
                phone_numbers: [],
                addresses: [],
                gender: 'male',
                languages: [],
                name_suffix: nil,
                date_of_birth: '1988-03-07',
                last_name: 'Hill',
                id: 'I1dyXvW00b',
                middle_name: '',
                first_name: 'Harold',
                ssn: ''
              },
              highlight: {
                last_name: [
                  '<em>Hill</em>'
                ]
              }
            }
          ]
        }
      }
      db_response = double(:response, body: db_results)

      expect(API).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to match array_including(
        a_hash_including('highlight' => { 'last_name' => '<em>Hill</em>' })
      )
    end
  end
end
