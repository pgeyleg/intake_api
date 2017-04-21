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
end
