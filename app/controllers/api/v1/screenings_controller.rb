# frozen_string_literal: true

module Api
  module V1
    class ScreeningsController < ApplicationController # :nodoc:
      def create
        screening = Screening.new(screening_params)
        screening.build_screening_address
        screening.screening_address.build_address
        screening.save!
        render json: ScreeningSerializer.new(screening)
          .as_json(include: ['participants.addresses',
                             'address',
                             'cross_reports']), status: :created
      end

      def show
        screening = Screening.find(screening_params[:id])
        render json: ScreeningSerializer.new(screening)
          .as_json(include: ['participants.addresses', 'address', 'cross_reports']), status: :ok
      end

      def update
        screening = Screening.find(screening_params[:id])
        screening.assign_attributes(screening_params)
        screening.address.assign_attributes(address_params)
        screening.save!
        render json: ScreeningSerializer.new(screening)
          .as_json(include: ['participants.addresses', 'address', 'cross_reports']), status: :ok
      end

      def index
        screenings = ScreeningsRepo.search_es_by(
          screening_decision_details,
          screening_decisions
        ).results
        render json: screenings.as_json(include: ['participants.addresses', 'address']), status: :ok
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
          :additional_information,
          :ended_at,
          :id,
          :incident_county,
          :incident_date,
          :location_type,
          :communication_method,
          :name,
          :report_narrative,
          :reference,
          :screening_decision_detail,
          :screening_decision,
          :started_at,
          :assignee,
          cross_reports_attributes: [
            :agency_type,
            :agency_name
          ]
        )
      end

      def screening_decision_details
        params[:screening_decision_details]
      end

      def screening_decisions
        params[:screening_decisions]
      end
    end
  end
end
