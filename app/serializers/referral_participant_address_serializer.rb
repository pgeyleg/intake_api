# frozen_string_literal: true

class ReferralParticipantAddressSerializer < ActiveModel::Serializer # :nodoc:
  attributes :street_address,
    :state,
    :city,
    :zip,
    :type
end
