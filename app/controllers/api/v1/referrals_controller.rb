# frozen_string_literal: true

module Api
  module V1
    class ReferralsController < ApplicationController # :nodoc:
      def create
        @referral = Referral.new(referral_params)
        @referral.build_referral_address
        @referral.referral_address.build_address
        @referral.save!
        render json: referral_json, status: :created
      end

      def show
        @referral = Referral.find(params[:id])
        render json: referral_json, status: :ok
      end

      def update
        @referral = Referral.find(params[:id])
        @referral.update!(referral_params)
        render json: referral_json, status: :ok
      end

      private

      def referral_json
        @referral.as_json(
          include: {
            referral_address: {
              include: :address, only: [:id, :address]
            }
          }
        )
      end

      def referral_params
        params.permit(
          :ended_at,
          :id,
          :incident_date,
          :location_type,
          :method_of_referral,
          :name,
          :reference,
          :started_at,
          referral_address_attributes: [
            :id,
            address_attributes: [
              :id,
              :street_address,
              :city,
              :state,
              :zip
            ]
          ]
        )
      end
    end
  end
end
