# frozen_string_literal: true
require 'rails_helper'

describe Participant do
  it { is_expected.to be_versioned }

  it 'is valid without a person_id' do
    participant = described_class.new(person_id: nil)
    participant.valid?
    expect(participant.errors).not_to have_key(:person)
  end

  it 'requires a screening' do
    participant = described_class.new(screening_id: nil)
    participant.valid?
    expect(participant.errors[:screening]).to include('must exist')
  end

  describe '#after_update' do
    let(:screening) { Screening.create! }
    let(:participant) do
      Participant.create!(
        screening: screening,
        roles: ['Victim', 'Perpetrator', 'Anonymous Reporter']
      )
    end
    let(:other_participant) do
      Participant.create!(screening: screening, roles: %w(Victim Perpetrator))
    end

    before do
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: participant.id,
        victim_id: other_participant.id)
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: other_participant.id,
        victim_id: participant.id)
    end

    it 'does not affect allegations if other values are updated' do
      expect do
        participant.update!(first_name: 'Jeff')
      end.to change(Allegation, :count).by(0)
    end

    it 'removes victim allegations when I am no longer a victim' do
      expect do
        participant.update!(roles: ['Perpetrator', 'Anonymous Reporter'])
      end.to change(Allegation, :count).by(-1)
    end

    it 'removes perpetrator allegations when I am no longer a perpetrator' do
      expect do
        participant.update!(roles: ['Victim', 'Anonymous Reporter'])
      end.to change(Allegation, :count).by(-1)
    end

    it 'removes all allegations when I no longer have roles' do
      expect do
        participant.update!(roles: [])
      end.to change(Allegation, :count).by(-2)
    end

    it 'removes all allegations if the only role remaining is a reporter' do
      expect do
        participant.update!(roles: ['Anonymous Reporter'])
      end.to change(Allegation, :count).by(-2)
    end
  end

  describe '#before_destroy' do
    let(:screening) { Screening.create! }
    let(:participant) { Participant.create!(screening: screening) }
    let(:other_participant) { Participant.create!(screening: screening) }
    let(:other_other_participant) { Participant.create!(screening: screening) }

    before do
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: participant.id,
        victim_id: other_participant.id)
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: other_participant.id,
        victim_id: participant.id)
      FactoryGirl.create(:allegation,
        screening: screening,
        perpetrator_id: other_participant.id,
        victim_id: other_other_participant.id)
    end

    it 'removes all allegations for a participant' do
      expect { participant.destroy }.to change(Allegation, :count).by(-2)
    end
  end
end
