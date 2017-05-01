# frozen_string_literal: true
require 'rails_helper'

describe Api::V2::PeopleSearchController do
  it { is_expected.to use_before_action :authenticate_request }

  describe '#index' do
    let(:highlight) do
      {
        order: 'score',
        number_of_fragments: 3,
        require_field_match: true,
        fields: {
          first_name: {},
          last_name: {},
          date_of_birth: {},
          ssn: {}
        }
      }
    end
    let(:fields) do
      %w(
        id first_name middle_name last_name name_suffix gender
        date_of_birth ssn languages races ethnicity
        addresses.id addresses.street_address
        addresses.city addresses.state addresses.zip
        addresses.type
        phone_numbers.id phone_numbers.number
        phone_numbers.type
        highlight
      )
    end
    let(:search_body) do
      {
        query: query,
        _source: fields,
        highlight: highlight
      }
    end

    context 'when search results are empty' do
      let(:search_response) { double(:search_response, body: empty_results) }
      let(:empty_results) do
        {
          'hits' => {
            'hits' => []
          }
        }
      end

      before do
        expect(API).to receive(:make_api_call)
          .with('/api/v1/dora/people/_search', :post, search_body)
          .and_return(search_response)
        get :index, params: { search_term: search_term }
      end

      context 'when search criteria provided is a string' do
        let(:search_term) { 'blah' }
        let(:query) do
          {
            bool: {
              should: [
                { match: { first_name: 'blah' } },
                { match: { last_name: 'blah' } }
              ]
            }
          }
        end

        it 'creates a search query for names' do
          assert_response :success
        end
      end

      context 'when search criteria is ten digit string' do
        let(:search_term) { '123456789' }
        let(:query) do
          {
            bool: {
              should: [
                { match: { first_name: '123456789' } },
                { match: { last_name: '123456789' } },
                { range: {
                  date_of_birth: {
                    gte: '1234||/y',
                    lte: '1234||/y',
                    format: 'yyyy'
                  }
                } },
                { match: { ssn: '123456789' } }
              ]
            }
          }
        end

        it 'creates a search query for ssn' do
          assert_response :success
        end
      end

      context 'when search criteria is a four digit string' do
        let(:search_term) { '2012' }
        let(:query) do
          {
            bool: {
              should: [
                { match: { first_name: '2012' } },
                { match: { last_name: '2012' } },
                { range: {
                  date_of_birth: {
                    gte: '2012||/y',
                    lte: '2012||/y',
                    format: 'yyyy'
                  }
                } }
              ]
            }
          }
        end

        it 'creates a search query for birth year' do
          assert_response :success
        end
      end

      context 'when search criteria is a date (mm/dd/yyyy)' do
        let(:search_term) { '4/3/2010' }
        let(:query) do
          {
            bool: {
              should: [
                { match: { first_name: '4/3/2010' } },
                { match: { last_name: '4/3/2010' } },
                { match: { date_of_birth: '2010-04-03' } },
                { range: {
                  date_of_birth: {
                    gte: '2010||/y',
                    lte: '2010||/y',
                    format: 'yyyy'
                  }
                } }
              ]
            }
          }
        end

        it 'creates a search query for birth date' do
          assert_response :success
        end
      end

      context 'when search criteria is a date (yyyy-mm-dd)' do
        let(:search_term) { '2010-04-03' }
        let(:query) do
          {
            bool: {
              should: [
                { match: { first_name: '2010-04-03' } },
                { match: { last_name: '2010-04-03' } },
                { match: { date_of_birth: '2010-04-03' } },
                { range: {
                  date_of_birth: {
                    gte: '2010||/y',
                    lte: '2010||/y',
                    format: 'yyyy'
                  }
                } }
              ]
            }
          }
        end

        it 'creates a search query for birth date' do
          assert_response :success
        end
      end
    end

    context 'when search returns highlighted results' do
      let(:search_term) { 'blah' }
      let(:search_response) { double(:search_response, body: results) }
      let(:results) do
        {
          'hits' => {
            'hits' => [
              {
                '_source' => {},
                'highlight' => {
                  'last_name' => ['<em>Hill</em>'],
                  'first_name' => ['<em>Phil</em>'],
                  'ssn' => ['<em>111225555</em>']
                }
              }
            ]
          }
        }
      end

      before do
        expect(API).to receive(:make_api_call)
          .and_return(search_response)
        get :index, params: { search_term: search_term }
      end

      it 'flattens values associated to highlight fields' do
        expect(JSON.parse(response.body)).to match array_including(
          a_hash_including(
            'highlight' => a_hash_including(
              'last_name' => '<em>Hill</em>',
              'first_name' => '<em>Phil</em>',
              'ssn' => '<em>111225555</em>'
            )
          )
        )
      end
    end
  end
end
