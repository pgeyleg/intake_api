# frozen_string_literal: true

class AddressSerializer < ActiveModel::Serializer # :nodoc:
  attributes :street_address, :state, :city, :zip, :type, :id
end
