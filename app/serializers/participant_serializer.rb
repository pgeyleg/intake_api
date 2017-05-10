# frozen_string_literal: true

class ParticipantSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :first_name,
    :middle_name,
    :last_name,
    :name_suffix,
    :gender,
    :ssn,
    :date_of_birth,
    :languages,
    :person_id,
    :races,
    :screening_id,
    :roles

  has_many :addresses
  has_many :phone_numbers
end
