module Api
  module V1
    class PeopleController < ApplicationController
      def create
        person = Person.create(person_params)
        render json: person, status: :created
      end

      def update
        person = Person.find(params[:id])
        person.update_attributes!(person_params)
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

      def person_params
        params.require(:person).permit(:first_name, :last_name)
      end
    end
  end
end
