# frozen_string_literal: true
require 'rails_helper'

describe Api::V1::ParticipantsController do
  it { is_expected.to use_before_action :authenticate_request }
end
