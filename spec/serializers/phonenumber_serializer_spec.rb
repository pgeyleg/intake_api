# frozen_string_literal: true
require 'rails_helper'

describe PhoneNumberSerializer do
  describe 'as_json' do
    let(:phone_number) do
      PhoneNumber.new(
        number: '917-901-8765',
        type: 'Home',
        created_at: '2016-12-03T22:08:38.204Z',
        updated_at: '2016-12-03T22:08:38.204Z'
      )
    end

    before { phone_number.save! }

    it 'returns the attributes of a phoneNumbers as a hash' do
      expect(described_class.new(phone_number).as_json).to eq(
        id: phone_number.id,
        number: '917-901-8765',
        type: 'Home',
        created_at: '2016-12-03T22:08:38.204Z',
        updated_at: '2016-12-03T22:08:38.204Z'
      )
    end
  end
end
