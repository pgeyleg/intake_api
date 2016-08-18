# frozen_string_literal: true
require 'rails_helper'

describe 'CORS' do
  it 'allows xhr requests from all sources' do
    get '/api/v1/people/1', nil, 'HTTP_ORIGIN' => '*'
    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
  end
end
