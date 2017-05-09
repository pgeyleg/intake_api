# frozen_string_literal: true

require 'rails_helper'

describe ReferralParticipantAddressSerializer do
  describe 'as_json' do
    let(:address) { FactoryGirl.build(:address) }

    it 'returns all attributes of a address except id' do
      expect(described_class.new(address).as_json).to eq(
        street_address: address.street_address,
        state: address.state,
        city: address.city,
        zip: address.zip,
        type: address.type
      )
    end
  end
end
