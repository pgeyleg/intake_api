# frozen_string_literal: true

module Api
  module V1
    class ScreeningsController < ApplicationController # :nodoc:
      def create
        screening = Screening.new(screening_params)
        screening.build_screening_address
        screening.screening_address.build_address
        screening.save!
        render json: ScreeningSerializer.new(screening), status: :created
      end

      def show
        screening = Screening.find(screening_params[:id])
        render json: ScreeningSerializer.new(screening), status: :ok
      end

      def update
        screening = Screening.find(screening_params[:id])
        screening.assign_attributes(screening_params)
        screening.address.assign_attributes(address_params)
        screening.save!
        render json: ScreeningSerializer.new(screening), status: :ok
      end

      def index
        screenings = ScreeningsRepo.search_es_by(response_times, screening_decisions).results
        render json: screenings.as_json, status: :ok
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

      def screening_params
        params.permit(
          :ended_at,
          :id,
          :incident_county,
          :incident_date,
          :location_type,
          :communication_method,
          :name,
          :report_narrative,
          :reference,
          :response_time,
          :screening_decision,
          :started_at,
          participant_ids: []
        )
      end

      def response_times
        params[:response_times]
      end

      def screening_decisions
        params[:screening_decisions]
      end
    end
  end
end
