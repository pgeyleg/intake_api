# frozen_string_literal: true
require 'rails_helper'

describe AddressSerializer do
  describe 'as_json' do
    let(:address) do
      Address.new(
        street_address: '9273 Corona St',
        state: 'NY',
        city: 'Jackson Heights',
        zip: '11372',
        type: 'Placement'
      )
    end

    before { address.save! }

    it 'returns the attributes of a address as a hash' do
      expect(described_class.new(address).as_json).to eq(
        id: address.id,
        street_address: '9273 Corona St',
        state: 'NY',
        city: 'Jackson Heights',
        zip: '11372',
        type: 'Placement'
      )
    end
  end
end
