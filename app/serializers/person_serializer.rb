# frozen_string_literal: true
class PersonSerializer < ActiveModel::Serializer
  has_one :address
  attributes :id, :first_name, :last_name, :gender, :ssn, :date_of_birth
end
