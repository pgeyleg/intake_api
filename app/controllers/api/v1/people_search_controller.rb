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
                { match: { last_name: params[:search_term] } },
                { match: { ssn: ssn } }
              ]
            }
          }
        )
        render json: people.map(&:to_h)
      end

      def ssn
        ssn = params[:search_term].match(/\d{3}-?\d{2}-?\d{4}/)
        if ssn
          ssn[0].gsub('-','')
        else
          params[:search_term]
        end
      end
    end
  end
end
