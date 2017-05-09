# frozen_string_literal: true

require 'rails_helper'

describe ReferralCrossReportSerializer do
  describe 'as_json' do
    let(:cross_report) { FactoryGirl.build(:cross_report) }

    it 'returns the attributes of a cross report with method and inform date' do
      expect(described_class.new(cross_report).as_json).to eq(
        agency_type: cross_report.agency_type,
        agency_name: cross_report.agency_name,
        method: 'Telephone Report', # This field is not currently being captured
        inform_date: '1996-01-01' # This field is not currently being captured
      )
    end
  end
end
