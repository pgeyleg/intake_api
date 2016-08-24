# frozen_string_literal: true

module Api
  module V1
    class ReferralsController < ApplicationController # :nodoc:
      def create
        referral = Referral.create(referral_params)
        render json: referral, status: :created
      end

      def show
        referral = Referral.find(params[:id])
        render json: referral, status: :ok
      end

      def update
        referral = Referral.find(params[:id])
        referral.update!(referral_params)
        render json: referral, status: :ok
      end

      private

      def referral_params
        params.permit(
          :city,
          :ended_at,
          :id,
          :incident_date,
          :location_type,
          :method_of_referral,
          :name,
          :reference,
          :started_at,
          :state,
          :street_address,
          :zip
        )
      end
    end
  end
end
