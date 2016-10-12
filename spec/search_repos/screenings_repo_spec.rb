# frozen_string_literal: true
require 'rails_helper'

describe ScreeningsRepo do
  describe '#serialize' do
    it 'returns the attributes of the screening record' do
      screening = double(:screening, attributes: 'my attributes')
      serialized_screening = described_class.new.serialize(screening)
      expect(serialized_screening).to include(screening.attributes)
    end
  end
end
