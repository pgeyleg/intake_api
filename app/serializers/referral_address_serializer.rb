# frozen_string_literal: true

class ReferralAddressSerializer < ActiveModel::Serializer # :nodoc:
  attributes :street_address, :state, :city, :zip, :type
end
