# frozen_string_literal: true

class ReferralAddressSerializer < ActiveModel::Serializer # :nodoc:
  attributes :city,
    :legacy_id,
    :legacy_source_table,
    :state,
    :street_address,
    :type,
    :zip

  def legacy_id
    nil
  end

  def legacy_source_table
    nil
  end

  def type
    'Other'
  end
end
