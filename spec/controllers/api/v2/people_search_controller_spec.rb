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
        date_of_birth ssn languages races ethnicity addresses phone_numbers
        highlight
      )
    end
    let(:results) do
      { took: 15,
        timed_out: false,
        _shards: { total: 10, successful: 10, failed: 0 },
        hits: { total: 0,
                max_score: 0.19245009,
                hits: [] } }
    end
    let(:response) { double(:response, body: results.as_json) }

    let(:name_query) do
      { bool: { should: [{ match: { first_name: 'blah' } }, { match: { last_name: 'blah' } }] } }
    end
    let(:name_search) do
      {
        query: name_query,
        _source: fields,
        highlight: highlight
      }
    end

    it 'creates a search query for names' do
      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, name_search)
        .and_return(response)
      get :index, params: { search_term: 'blah' }
    end

    let(:ssn_query) do
      { bool: { should: [
        { match: { first_name: '123456789' } },
        { match: { last_name: '123456789' } },
        { prefix: { date_of_birth: '1234' } },
        { match: { ssn: '123456789' } }
      ] } }
    end
    let(:ssn_search) do
      {
        query: ssn_query,
        _source: fields,
        highlight: highlight
      }
    end

    it 'creates a search query for ssn' do
      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, ssn_search)
        .and_return(response)
      get :index, params: { search_term: '123456789' }
    end

    let(:birth_year_query) do
      { bool: { should: [
        { match: { first_name: '2012' } },
        { match: { last_name: '2012' } },
        { prefix: { date_of_birth: '2012' } }
      ] } }
    end
    let(:birth_year_search) do
      {
        query: birth_year_query,
        _source: fields,
        highlight: highlight
      }
    end

    it 'creates a search query for birth year' do
      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, birth_year_search)
        .and_return(response)
      get :index, params: { search_term: '2012' }
    end

    let(:birth_date_query) do
      { bool: { should: [
        { match: { first_name: '4/3/2010' } },
        { match: { last_name: '4/3/2010' } },
        { match: { date_of_birth: '2010-04-03' } },
        { prefix: { date_of_birth: '2010' } }
      ] } }
    end
    let(:birth_date_search) do
      {
        query: birth_date_query,
        _source: fields,
        highlight: highlight
      }
    end

    it 'creates a search query for birth date' do
      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, birth_date_search)
        .and_return(response)
      get :index, params: { search_term: '4/3/2010' }
    end
  end
end
