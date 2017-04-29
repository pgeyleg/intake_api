# frozen_string_literal: true
require 'rails_helper'

describe CrossReportSerializer do
  describe 'as_json' do
    let(:cross_report) do
      FactoryGirl.build(
        :cross_report,
        agency_type: 'District attorney',
        agency_name: 'Sacramento attorney'
      )
    end

    it 'returns the attributes of a cross report on a hash' do
      expect(described_class.new(cross_report).as_json).to eq(
        agency_type: 'District attorney',
        agency_name: 'Sacramento attorney'
      )
    end
  end
end
