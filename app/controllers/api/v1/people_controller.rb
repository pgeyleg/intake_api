# frozen_string_literal: true

module Api
  module V1
    class PeopleController < ApplicationController # :nodoc:
      def create
        @person = Person.new(person_params)
        @person.build_person_address
        @person.person_address.build_address(address_params)
        @person.save!
        render json: @person, status: :created
      end

      def update
        person = Person.find(params[:id])
        person.update_attributes!(person_params)
        person.address.update_attributes!(address_params)
        render json: person, status: :ok
      end

      def show
        person = Person.find(params[:id])
        render json: person, status: :ok
      end

      def destroy
        person = Person.find(params[:id])
        person.destroy
        head :no_content
      end

      private

      def address_params
        params.require(:address).permit(
          :id,
          :street_address,
          :city,
          :state,
          :zip
        )
      end

      def person_params
        params.permit(
          :first_name,
          :middle_name,
          :last_name,
          :name_suffix,
          :gender,
          :date_of_birth,
          :ssn
        )
      end
    end
  end
end
