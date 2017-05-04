# frozen_string_literal: true
require 'rails_helper'

describe PeopleSearchQueryFormatter do
  let(:search_term) { '' }
  let(:formatted_query) { PeopleSearchQueryFormatter.new(search_term).format_query }

  let(:expected_query) do
    {
      query: {
        bool: {
          should: query
        }
      },
      _source: fields,
      highlight: highlight
    }
  end

  let(:query) do
    [
      { prefix: { first_name: '' } },
      { prefix: { last_name: '' } }
    ]
  end

  let(:fields) do
    %w(id first_name middle_name last_name name_suffix gender
       date_of_birth ssn languages races ethnicity
       addresses.id addresses.street_address
       addresses.city addresses.state addresses.zip
       addresses.type
       phone_numbers.id phone_numbers.number
       phone_numbers.type
       highlight)
  end

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

  it 'does not explode if there are no params' do
    expect(formatted_query).to eq(expected_query)
  end

  context 'when search criteria provided is non-numeric text' do
    let(:search_term) { 'blah' }
    let(:query) do
      [
        { prefix: { first_name: 'blah' } },
        { prefix: { last_name: 'blah' } }
      ]
    end

    it 'creates a search query for names' do
      expect(formatted_query).to eq(expected_query)
    end
  end

  context 'when search criteria is ten digit string' do
    let(:search_term) { '123456789' }
    let(:query) do
      [
        { prefix: { first_name: '123456789' } },
        { prefix: { last_name: '123456789' } },
        { range: {
          date_of_birth: {
            gte: '1234||/y',
            lte: '1234||/y',
            format: 'yyyy'
          }
        } },
        { match: { ssn: '123456789' } }
      ]
    end

    it 'creates a search query for ssn' do
      expect(formatted_query).to eq(expected_query)
    end
  end

  context 'when search criteria is a four digit string' do
    let(:search_term) { '2012' }
    let(:query) do
      [
        { prefix: { first_name: '2012' } },
        { prefix: { last_name: '2012' } },
        { range: {
          date_of_birth: {
            gte: '2012||/y',
            lte: '2012||/y',
            format: 'yyyy'
          }
        } }
      ]
    end

    it 'creates a search query for birth year' do
      expect(formatted_query).to eq(expected_query)
    end
  end

  context 'when search criteria is a date (mm/dd/yyyy)' do
    let(:search_term) { '4/3/2010' }
    let(:query) do
      [
        { prefix: { first_name: '4/3/2010' } },
        { prefix: { last_name: '4/3/2010' } },
        { match: { date_of_birth: '2010-04-03' } },
        { range: {
          date_of_birth: {
            gte: '2010||/y',
            lte: '2010||/y',
            format: 'yyyy'
          }
        } }
      ]
    end

    it 'creates a search query for birth date' do
      expect(formatted_query).to eq(expected_query)
    end
  end

  context 'when search criteria is a date (yyyy-mm-dd)' do
    let(:search_term) { '2010-04-03' }
    let(:query) do
      [
        { prefix: { first_name: '2010-04-03' } },
        { prefix: { last_name: '2010-04-03' } },
        { match: { date_of_birth: '2010-04-03' } },
        { range: {
          date_of_birth: {
            gte: '2010||/y',
            lte: '2010||/y',
            format: 'yyyy'
          }
        } }
      ]
    end

    it 'creates a search query for birth date' do
      expect(formatted_query).to eq(expected_query)
    end
  end
end
