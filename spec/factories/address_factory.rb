# frozen_string_literal: true
FactoryGirl.define do
  factory :address, class: Address do
    zip { FFaker::AddressUS.zip_code }
    street_address { FFaker::Address.street_address }
    type { Address::ADDRESS_TYPES.sample }
    city { FFaker::Address.city }
    state { FFaker::AddressUS.us_state_abbr }
  end
end
