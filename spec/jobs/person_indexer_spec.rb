# frozen_string_literal: true

require 'rails_helper'

describe PersonIndexer do
  it 'indexes the person data in elastic search when person is found' do
    person = double(:person, id: '1')
    allow(Person).to receive(:find)
      .with(person.id)
      .and_return(person)
    expect(PeopleRepo).to receive(:save).with(person)
    described_class.perform(person.id)
  end

  it 'deletes the person data in elastic search when person is not found' do
    person = double(:person, id: '1')
    allow(Person).to receive(:find)
      .with(person.id)
      .and_raise(ActiveRecord::RecordNotFound)
    expect(PeopleRepo).to receive(:delete).with(person.id)
    described_class.perform(person.id)
  end
end
