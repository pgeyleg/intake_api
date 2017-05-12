# frozen_string_literal: true

class ReferralCrossReportSerializer < ActiveModel::Serializer # :nodoc:
  attributes :agency_name,
    :agency_type,
    :inform_date, # This field is not currently being captured
    :legacy_id,
    :legacy_source_table,
    :method # This field is not currently being captured

  def inform_date
    '1996-01-01'
  end

  def legacy_id
    nil
  end

  def legacy_source_table
    nil
  end

  def method
    'Telephone Report'
  end
end
