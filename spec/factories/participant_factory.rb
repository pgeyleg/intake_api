# frozen_string_literal: true

FactoryGirl.define do
  factory :participant do
    screening
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    gender { %w[male female].sample }
    ssn { FFaker::SSN.ssn }
    date_of_birth { 12.years.ago.to_date }
    roles { Array.new(1) { Participant::ROLE_TYPES.sample } }
    languages { %w[Turkish German English Spanish Russian].sample(rand(0..2)) }
    trait :with_address do
      addresses { build_list :address, 1 }
    end

    trait :with_phone_number do
      phone_numbers { build_list :phone_number, 1 }
    end
  end
end
