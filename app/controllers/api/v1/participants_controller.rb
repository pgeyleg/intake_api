# frozen_string_literal: true

module Api
  module V1
    class ParticipantsController < ApplicationController # :nodoc:
      def create
        participant = Participant.create!(participant_params)
        render json: participant, status: :created
      end

      private

      def participant_params
        params.permit(
          :date_of_birth,
          :first_name,
          :gender,
          :last_name,
          :person_id,
          :screening_id,
          :ssn
        )
      end
    end
  end
end
