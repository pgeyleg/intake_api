# frozen_string_literal: true

require 'rails_helper'

describe ReferralAddressSerializer do
  describe 'as_json' do
    let(:address) { FactoryGirl.build(:address) }

    it "returns the attributes of a address with type as 'Other'" do
      expect(described_class.new(address).as_json).to eq(
        city: address.city,
        legacy_id: nil,
        legacy_source_table: nil,
        state: address.state,
        street_address: address.street_address,
        type: 'Other',
        zip: address.zip
      )
    end
  end
end
