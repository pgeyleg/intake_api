# frozen_string_literal: true
class ScreeningSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :ended_at,
    :incident_county,
    :incident_date,
    :location_type,
    :communication_method,
    :name,
    :report_narrative,
    :reference,
    :response_time,
    :screening_decision,
    :started_at

  has_one :address
  has_many :participants, serializer: ParticipantSerializer
end
