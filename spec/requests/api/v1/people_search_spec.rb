# frozen_string_literal: true
require 'rails_helper'

describe 'People Search API', elasticsearch: true do
  describe 'GET /api/v1/people_search' do
    context 'when search term does not match on a persons name' do
      it 'searches against people index' do
        get '/api/v1/people_search?search_term=Deborah'
        assert_response :success
        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context 'when search term matches on a persons name' do
      before do
        Person.create [{
          first_name: 'Deborah',
          middle_name: 'Ann',
          last_name: 'Harry'
        }, {
          first_name: 'David',
          middle_name: 'Jon',
          last_name: 'Gilmour'
        }]
        PeopleRepo.client.indices.flush
      end

      it 'searches against people index' do
        get '/api/v1/people_search?search_term=Deborah'
        assert_response :success
        expect(JSON.parse(response.body)).to match array_including(
          a_hash_including(
            'first_name' => 'Deborah',
            'middle_name' => 'Ann',
            'last_name' => 'Harry'
          )
        )
      end
    end
  end
end
