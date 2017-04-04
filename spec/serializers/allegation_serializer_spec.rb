# frozen_string_literal: true
require 'rails_helper'

describe AllegationSerializer do
  describe 'as_json' do
    let(:screening) { Screening.create }
    let(:perpetrator) { Participant.create(screening: screening) }
    let(:victim) { Participant.create(screening: screening) }
    let(:allegation) do
      Allegation.new(
        screening: screening,
        allegation_types: %w(string1 string2),
        perpetrator_id: perpetrator.id,
        victim_id: victim.id
      )
    end

    before { allegation.save! }

    it 'returns the attributes of an allegation as a hash' do
      expect(described_class.new(allegation).as_json).to eq(
        id: allegation.id,
        screening_id: screening.id,
        allegation_types: %w(string1 string2),
        perpetrator_id: perpetrator.id,
        victim_id: victim.id
      )
    end
  end
end
