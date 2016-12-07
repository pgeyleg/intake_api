# frozen_string_literal: true
class PhoneNumberSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :number,
    :type,
    :created_at,
    :updated_at
end
