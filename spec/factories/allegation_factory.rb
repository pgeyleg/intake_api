# frozen_string_literal: true
# This will guess the User class
FactoryGirl.define do
  factory :allegation do
    screening
    victim factory: :participant
    perpetrator factory: :participant
    allegation_types do
      Array.new(rand(1..4)) do
        [
          'General neglect',
          'Severe neglect',
          'Physical abuse',
          'Sexual abuse',
          'Emotional abuse',
          'Caretaker absent/incapacity',
          'Exploitation',
          'Sibling at risk'
        ].sample
      end
    end
  end
end
