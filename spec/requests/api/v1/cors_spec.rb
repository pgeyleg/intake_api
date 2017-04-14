# frozen_string_literal: true
require 'rails_helper'

describe 'CORS', skip_auth: true do
  it 'allows xhr requests from all sources' do
    person = Person.create
    get "/api/v1/people/#{person.id}", env: { 'HTTP_ORIGIN' => '*' }
    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
  end
end
