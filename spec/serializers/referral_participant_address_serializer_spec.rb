# frozen_string_literal: true

require 'rails_helper'

describe ReferralParticipantAddressSerializer do
  describe 'as_json' do
    let(:address) { FactoryGirl.build(:address) }

    it 'returns all attributes of a address with legacy id and table' do
      expect(described_class.new(address).as_json).to eq(
        city: address.city,
        legacy_id: nil,
        legacy_source_table: nil,
        state: address.state,
        street_address: address.street_address,
        type: address.type,
        zip: address.zip
      )
    end
  end
end
