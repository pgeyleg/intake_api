# frozen_string_literal: true

class PersonSerializer < ActiveModel::Serializer # :nodoc:
  has_many :addresses
  has_many :phone_numbers
  attributes :id,
    :first_name,
    :middle_name,
    :last_name,
    :name_suffix,
    :gender,
    :ssn,
    :date_of_birth,
    :languages,
    :races,
    :ethnicity
end
