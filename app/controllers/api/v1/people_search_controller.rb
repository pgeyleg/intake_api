# frozen_string_literal: true

# PeopleSearchController is the controller responsible for accessing People ES index
module Api
  module V1
    class PeopleSearchController < ApplicationController # :nodoc:
      def index
        people = PeopleRepo.search(
          query: {
            bool: {
              should: [
                { match: { first_name: params[:search_term] } },
                { match: { last_name: params[:search_term] } }
              ]
            }
          }
        )
        render json: people.map(&:to_h)
      end
    end
  end
end
