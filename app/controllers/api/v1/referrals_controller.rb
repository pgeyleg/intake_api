# frozen_string_literal: true

module Api
  module V1
    class ReferralsController < ApplicationController # :nodoc:
      def create
        referral = Referral.create(referral_params)
        render json: referral, status: :created
      end

      private

      def referral_params
        params.require(:referral).permit(:reference)
      end
    end
  end
end
