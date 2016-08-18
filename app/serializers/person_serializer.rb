# frozen_string_literal: true
class PersonSerializer < ActiveModel::Serializer # :nodoc:
  has_one :address
  attributes :id, :first_name, :last_name, :gender, :ssn, :date_of_birth
end
