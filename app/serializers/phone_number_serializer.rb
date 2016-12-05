# frozen_string_literal: true
class PhoneNumberSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :phone_number,
    :phone_number_type,
    :created_at,
    :updated_at
end
