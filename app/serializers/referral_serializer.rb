# frozen_string_literal: true

class ReferralSerializer < ActiveModel::Serializer # :nodoc:
  attributes :additional_information,
    :allegations,
    :assignee,
    :communication_method,
    :cross_reports,
    :ended_at,
    :id,
    :incident_county,
    :incident_date,
    :location_type,
    :name,
    :reference,
    :report_narrative,
    :response_time,
    :screening_decision,
    :screening_decision_detail,
    :started_at

  has_one :address, serializer: ReferralAddressSerializer
  has_many :participants, serializer: ReferralParticipantSerializer
  has_many :cross_reports, serializer: ReferralCrossReportSerializer

  def allegations
    object.allegations.map do |allegation|
      allegation.allegation_types.map do |type|
        {
          victim_person_id: allegation.victim.id,
          perpetrator_person_id: allegation.perpetrator.id,
          type: type,
          county: object.incident_county
        }
      end
    end.flatten
  end

  def response_time
    object.screening_decision_detail
  end
end
