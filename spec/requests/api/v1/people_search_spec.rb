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
      let!(:deborah) do
        Person.create!(first_name: 'Deborah', middle_name: 'Ann', last_name: 'Harry')
      end
      let!(:david) do
        Person.create!(first_name: 'David', middle_name: 'Jon', last_name: 'Gilmour')
      end
      before { PeopleRepo.client.indices.flush }
      let(:body) { JSON.parse(response.body) }

      it 'searches against people index' do
        get '/api/v1/people_search?search_term=Deborah'
        assert_response :success
        expect(body).to match array_including(
          a_hash_including(
            'id' => deborah.id,
            'first_name' => 'Deborah',
            'middle_name' => 'Ann',
            'last_name' => 'Harry'
          )
        )
        expect(body).to_not match array_including(
          a_hash_including(
            'id' => david.id,
            'first_name' => 'David',
            'middle_name' => 'Jon',
            'last_name' => 'Gilmour'
          )
        )
      end
    end
  end
end
