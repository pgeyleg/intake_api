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
    :screening_decision,
    :screening_decision_detail,
    :started_at

  has_one :address
  has_many :participants, serializer: ParticipantSerializer

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

  def cross_reports
    object.cross_reports.map do |cross_report|
      {
        agency_type: cross_report.agency_type,
        agency_name: cross_report.agency_name,
        method: 'Telephone Report', # This field is not currently being captured
        inform_date: '1996-01-01' # This field is not currently being captured
      }
    end
  end
end
