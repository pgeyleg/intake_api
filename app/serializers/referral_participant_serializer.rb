# frozen_string_literal: true

class ReferralParticipantSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id,
    :first_name,
    :last_name,
    :gender,
    :ssn,
    :date_of_birth,
    :person_id,
    :screening_id,
    :roles

  has_many :addresses, serializer: ReferralAddressSerializer
end
