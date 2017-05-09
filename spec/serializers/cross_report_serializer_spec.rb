# frozen_string_literal: true

require 'rails_helper'

describe CrossReportSerializer do
  describe 'as_json' do
    let(:cross_report) { FactoryGirl.build(:cross_report) }

    it 'returns the attributes of a cross report on a hash' do
      expect(described_class.new(cross_report).as_json).to eq(
        agency_type: cross_report.agency_type,
        agency_name: cross_report.agency_name
      )
    end
  end
end
