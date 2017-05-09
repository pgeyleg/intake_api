# frozen_string_literal: true

class ReferralCrossReportSerializer < ActiveModel::Serializer # :nodoc:
  attributes :agency_name,
    :agency_type,
    :method, # This field is not currently being captured
    :inform_date # This field is not currently being captured

  def method
    'Telephone Report'
  end

  def inform_date
    '1996-01-01'
  end
end
