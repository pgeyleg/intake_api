# frozen_string_literal: true
require 'rails_helper'

describe ReferralsRepo do
  describe '#serialize' do
    it 'returns the attributes of the referral record' do
      referral = double(:referral, attributes: 'my attributes')
      serialized_referral = described_class.new.serialize(referral)
      expect(serialized_referral).to include(referral.attributes)
    end
  end
end
