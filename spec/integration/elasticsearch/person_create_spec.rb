# frozen_string_literal: true
require 'rails_helper'

describe 'Person Active Record and Elastic Search integration' do
  it 'creates a person document in ES', truncation: true do
    PeopleRepo.create_index! force: true
    person = Person.create(first_name: 'Bart', last_name: 'Simpson')
    person_data_from_es = PeopleRepo.find(person.id)
    expect(person_data_from_es['first_name']).to eq(person.first_name)
    expect(person_data_from_es['middle_name']).to eq(person.middle_name)
    expect(person_data_from_es['last_name']).to eq(person.last_name)
  end
end
