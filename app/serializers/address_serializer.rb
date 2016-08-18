# frozen_string_literal: true
class AddressSerializer < ActiveModel::Serializer
  attributes :street_address, :state, :city, :zip
end
