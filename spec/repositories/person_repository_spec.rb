# frozen_string_literal: true
require 'rails_helper'

describe PersonRepository do
  describe '.find' do
    let(:response_body) do
      {
        'took': 1,
        'timed_out': false,
        '_shards': {
          'total': 5,
          'successful': 5,
          'failed': 0
        },
        'hits': {
          'total': 0,
          'max_score': nil,
          'hits': hits
        }
      }
    end
    let(:response) { double(:response, body: response_body) }

    before do
      fields = %w(id)
      query = {
        query: {
          bool: {
            must: [
              {
                match: {
                  id: id_string
                }
              }
            ]
          }
        },
        _source: fields
      }

      expect(API).to receive(:make_api_call)
        .with('/api/v1/dora/people/_search', :post, query)
        .and_return(response)
    end

    context 'searching with no ids' do
      let(:ids) { [] }
      let(:id_string) { '' }
      let(:hits) { [] }

      it 'returns an empty set' do
        people = described_class.find(ids)
        expect(people).to eq []
      end
    end

    context 'searching by one id as a string' do
      let(:ids) { '123456788' }
      let(:id_string) { '123456788' }
      let(:hits) { [{ id: '123456788' }] }

      it 'returns the existing person' do
        people = described_class.find(ids)
        expect(people.first[:id]).to eq('123456788')
      end
    end

    context 'searching by one id in an array' do
      let(:ids) { ['123456788'] }
      let(:id_string) { '123456788' }
      let(:hits) { [{ id: '123456788' }] }

      it 'returns the existing person' do
        people = described_class.find(ids)
        expect(people.first[:id]).to eq(ids.first)
      end
    end

    context 'searching by multiple ids' do
      let(:ids) { %w(123456788 123456780) }
      let(:id_string) { '123456788 || 123456780' }
      let(:hits) { [{ id: '123456788' }, { id: '123456780' }] }

      it 'returns the existing person' do
        people = described_class.find(ids)
        expect(people.first[:id]).to eq(ids.first)
        expect(people.second[:id]).to eq(ids.second)
      end
    end
  end
end
