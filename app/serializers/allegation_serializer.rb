# frozen_string_literal: true
class AllegationSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :screening_id, :perpetrator_id, :victim_id, :allegation_types
end
