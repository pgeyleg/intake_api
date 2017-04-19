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
    let(:query) do
      { bool: { should: [{ match: { first_name: 'blah' } }, { match: { last_name: 'blah' } }] } }
    end
    let(:full_query) do
      {
        query: query,
        _source: %w(
          id first_name middle_name last_name name_suffix
          gender date_of_birth ssn languages races ethnicity
          addresses phone_numbers highlight
        ),
        highlight: highlight
      }
    end
    let(:results) do
      { took: 15,
        timed_out: false,
        _shards: { total: 10, successful: 10, failed: 0 },
        hits: { total: 1,
                max_score: 0.19245009,
                hits: [{ _index: 'people',
                         _type: 'person',
                         _id: '1',
                         _score: 0.19245009,
                         _source: { addresses: [],
                                    gender: nil,
                                    languages: [],
                                    ethnicity: nil,
                                    name_suffix: nil,
                                    date_of_birth: '1982-11-23',
                                    last_name: 'Harry',
                                    middle_name: 'Ann',
                                    ssn: '663298776',
                                    phone_numbers: [],
                                    races: nil,
                                    id: '1',
                                    first_name: 'Deborah' } }] } }
    end
    let(:response) { double(:response, body: results.as_json) }

    before do
      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, full_query)
        .and_return(response)
    end

    it 'returns the people results' do
      person_results = get :index, params: { search_term: 'blah' }
      expect(JSON.parse(person_results.body)).to match array_including(
        a_hash_including(
          'id' => '1',
          'first_name' => 'Deborah',
          'last_name' => 'Harry',
          'middle_name' => 'Ann',
          'ssn' => '663298776',
          'date_of_birth' => '1982-11-23'
        )
      )
    end
  end
end
