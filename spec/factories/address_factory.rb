# frozen_string_literal: true
FactoryGirl.define do
  factory :address, class: Address do
    type { %w(Home School Work Placement Homeless Other).sample }
    zip { %w(22070 95832 31123 00321).sample }
  end
end
