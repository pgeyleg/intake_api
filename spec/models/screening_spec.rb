# frozen_string_literal: true

require 'rails_helper'

describe Screening do
  it { is_expected.to be_versioned }

  with_versioning do
    it 'tracks changes made to screenings' do
      screening = create :screening
      expect(screening.versions.count).to eq(1)
      screening.update_attributes(name: 'Best screening EVAR')
      expect(screening.versions.count).to eq(2)
    end
  end

  describe '.people_ids' do
    let(:screening) { FactoryGirl.create :screening }
    let!(:part1) { FactoryGirl.create :participant, screening: screening }
    let!(:part2) do
      FactoryGirl.create :participant,
        screening: screening,
        person: FactoryGirl.create(:person)
    end
    let!(:part3) do
      FactoryGirl.create :participant,
        screening: screening,
        person: FactoryGirl.create(:person)
    end

    it 'returns the person ids of all participants on the screening, with no nil values' do
      expect(screening.people_ids).to contain_exactly(part2.person_id, part3.person_id)
    end
  end
end
