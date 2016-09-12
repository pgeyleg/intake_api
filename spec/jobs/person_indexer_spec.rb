# frozen_string_literal: true
require 'rails_helper'

describe 'PersonIndexer' do
  it 'indexes the person data in elastic search' do
    person = Person.create(first_name: 'bart', last_name: 'simpson')
    expect(PeopleRepo).to receive(:save).with(person)
    PersonIndexer.new.perform(person.id)
  end
end
