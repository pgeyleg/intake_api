# frozen_string_literal: true
FactoryGirl.define do
  factory :phone_number, class: PhoneNumber do
    type { %w(Cell Home Work Other).sample }
    number { ['571-456-7689', '352.789.1245', '9436587138', '943 549 6437'].sample }
  end
end
