# frozen_string_literal: true

class ReferralParticipantSerializer < ActiveModel::Serializer # :nodoc:
  attributes :date_of_birth,
    :first_name,
    :gender,
    :id,
    :last_name,
    :legacy_id,
    :legacy_source_table,
    :person_id,
    :roles,
    :screening_id,
    :ssn

  has_many :addresses, serializer: ReferralParticipantAddressSerializer

  def legacy_id
    nil
  end

  def legacy_source_table
    nil
  end
end
