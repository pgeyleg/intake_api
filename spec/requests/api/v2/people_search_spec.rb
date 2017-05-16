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
      db_results = { hits: { hits: [] } }
      db_response = double(:response, body: db_results)

      expect(TPT).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'returns an array of people' do
      db_results = {
        hits: {
          hits: [
            { _source: { id: 'I1dyXvW00b' } },
            { _source: { id: 'KKN1s2b75C' } }
          ]
        }
      }
      db_response = double(:response, body: db_results)

      expect(TPT).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to match array_including(
        a_hash_including('id' => 'I1dyXvW00b'),
        a_hash_including('id' => 'KKN1s2b75C')
      )
    end

    it 'includes highlighting' do
      db_results = {
        hits: {
          hits: [
            {
              _source: { id: 'I1dyXvW00b' },
              highlight: { last_name: ['<em>Hill</em>'] }
            }
          ]
        }
      }
      db_response = double(:response, body: db_results)

      expect(TPT).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=Hill'
      assert_response :success
      expect(JSON.parse(response.body)).to match array_including(
        a_hash_including('highlight' => { 'last_name' => '<em>Hill</em>' })
      )
    end

    it 'removes all but last four digits of ssn' do
      db_results = {
        hits: {
          hits: [
            {
              _source: {
                id: 'I1dyXvW00b',
                ssn: '1234445555'
              },
              highlight: { ssn: ['<em>1234445555</em>'] }
            }
          ]
        }
      }
      db_response = double(:response, body: db_results)

      expect(TPT).to receive(:make_api_call)
        .with(nil, '/people_search_path', :post, any_args)
        .and_return(db_response)

      get '/api/v2/people_search?search_term=123445555'
      assert_response :success
      expect(JSON.parse(response.body)).to match array_including(
        a_hash_including(
          'ssn' => '5555',
          'highlight' => { 'ssn' => '<em>5555</em>' }
        )
      )
    end
  end
end
