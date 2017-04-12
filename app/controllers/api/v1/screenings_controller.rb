# frozen_string_literal: true

module Api
  module V1
    class ScreeningsController < ApplicationController # :nodoc:
      PERMITTED_PARAMS = [
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
        cross_reports: [
          :agency_type,
          :agency_name
        ],
        allegations: [
          :perpetrator_id,
          :victim_id,
          allegation_types: []
        ]
      ].freeze

      def create
        screening = Screening.new(transformed_params)
        screening.build_screening_address
        screening.screening_address.build_address
        screening.save!
        render json: ScreeningSerializer.new(screening)
          .as_json(include: ['participants.addresses',
                             'participants.phone_numbers',
                             'address',
                             'cross_reports',
                             'allegations']), status: :created
      end

      def show
        screening = Screening.find(screening_params[:id])
        render json: ScreeningSerializer.new(screening)
          .as_json(include:
            [
              'participants.addresses',
              'participants.phone_numbers',
              'address',
              'allegations',
              'cross_reports'
            ]), status: :ok
      end

      def update
        screening = Screening.find(transformed_params[:id])

        screening.allegations.destroy_all
        screening.assign_attributes(transformed_params)
        screening.address.assign_attributes(address_params)
        screening.save!
        render json: ScreeningSerializer.new(screening)
          .as_json(include:
        [
          'participants.addresses',
          'participants.phone_numbers',
          'address',
          'allegations',
          'cross_reports'
        ]), status: :ok
      end

      def index
        screenings = ScreeningsRepo.search_es_by(
          screening_decision_details,
          screening_decisions
        ).results
        render json: screenings.as_json(
          include: ['participants.addresses', 'address', 'participants.phone_numbers']
        ), status: :ok
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

      def transformed_params
        screening_params.tap do |params|
          params[:allegations_attributes] = params.delete(:allegations) || []
          params[:cross_reports_attributes] = params.delete(:cross_reports) || []
        end
      end

      def screening_params
        params.permit(*PERMITTED_PARAMS)
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
