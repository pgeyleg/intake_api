# frozen_string_literal: true
class ReferralSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :created_at,
    :ended_at,
    :incident_county,
    :incident_date,
    :location_type,
    :method_of_referral,
    :name,
    :narrative,
    :reference,
    :response_time,
    :screening_decision,
    :started_at

  has_one :address
end
