# frozen_string_literal: true
require 'rails_helper'

describe PeopleRepo do
  describe '#serialize' do
    it 'returns the attributes of the person record' do
      person = Person.new(
        first_name: 'bart',
        last_name: 'simpson',
        gender: 'male'
      )
      serialized_person = PeopleRepo.new.serialize(person)

      expect(serialized_person).to include(person.attributes)
    end
  end
end
