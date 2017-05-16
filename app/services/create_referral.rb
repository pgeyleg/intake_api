# frozen_string_literal: true

class CreateReferral # :nodoc:
  def initialize; end

  def call(screening_id:, security_token:)
    screening = Screening.find(screening_id)
    TPT.make_api_call(
      security_token,
      Rails.application.routes.url_helpers.tpt_api_v1_referrals_path,
      :post,
      referral_attributes(screening)
    )
  end

  private

  def referral_attributes(screening)
    included_associations = %w[participants.addresses address cross_reports]
    ReferralSerializer.new(screening).as_json(include: included_associations)
  end
end
