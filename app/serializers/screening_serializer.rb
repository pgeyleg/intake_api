# frozen_string_literal: true
class ScreeningSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :additional_information,
    :ended_at,
    :incident_county,
    :incident_date,
    :location_type,
    :communication_method,
    :name,
    :report_narrative,
    :reference,
    :screening_decision_detail,
    :screening_decision,
    :started_at,
    :assignee

  has_one :address
  has_many :participants, serializer: ParticipantSerializer
  has_many :cross_reports, serializer: CrossReportSerializer
  has_many :allegations
end
