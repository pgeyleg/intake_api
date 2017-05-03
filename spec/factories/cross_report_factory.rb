# frozen_string_literal: true
FactoryGirl.define do
  factory :cross_report, class: CrossReport do
    agency_type do
      ['District attorney',
       'Law enforcement',
       'Department of justice',
       'Licensing'].sample
    end
    agency_name { FFaker::Name.name }
  end
end
