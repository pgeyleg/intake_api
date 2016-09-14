# frozen_string_literal: true

module Api
  module V1
    class ReferralsController < ApplicationController # :nodoc:
      def create
        @referral = Referral.new(referral_params)
        @referral.build_referral_address
        @referral.referral_address.build_address
        @referral.save!
        render json: ReferralSerializer.new(@referral), status: :created
      end

      def show
        @referral = Referral.find(referral_params[:id])
        render json: ReferralSerializer.new(@referral), status: :ok
      end

      def update
        @referral = Referral.find(referral_params[:id])
        @referral.assign_attributes(referral_params)
        @referral.address.assign_attributes(address_params)
        @referral.save!
        render json: ReferralSerializer.new(@referral), status: :ok
      end

      def index
        @referrals = Referral.all
        render json: @referrals, status: :ok
      end

      private

      def address_params
        params.require(:address).permit(
          :street_address,
          :city,
          :state,
          :zip
        )
      end

      def referral_params
        params.permit(
          :ended_at,
          :id,
          :incident_county,
          :incident_date,
          :location_type,
          :method_of_referral,
          :name,
          :narrative,
          :reference,
          :response_time,
          :screening_decision,
          :started_at
        )
      end
    end
  end
end
