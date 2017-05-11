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
    middle_name { FFaker::Name.last_name }
    name_suffix { FFaker::Name.suffix }
    races do
      Array.new(rand(0..2)) do
        race = ['White', 'Black or African American', 'Asian', 'Unknown'].sample
        race_detail = %w[European Caribbean Korean Ethiopian].sample
        {
          race: race,
          race_detail: race_detail
        }
      end
    end
    ethnicity do
      hispanic_latino_origin = ['Yes', 'No', nil, nil].sample
      ethnicity_detail = ['Mexican', 'Costa Rican', 'Mayan'].sample
      {
        hispanic_latino_origin: hispanic_latino_origin,
        ethnicity_detail: hispanic_latino_origin.present? ? ethnicity_detail : nil
      }
    end

    trait :with_address do
      addresses { build_list :address, 1 }
    end

    trait :with_phone_number do
      phone_numbers { build_list :phone_number, 1 }
    end
  end
end
