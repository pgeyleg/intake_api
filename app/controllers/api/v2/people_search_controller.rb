# frozen_string_literal: true

# PeopleSearchController is the controller responsible for accessing People ES index
module Api
  module V2
    class PeopleSearchController < ApplicationController # :nodoc:
      include AuthenticationConcern

      PEOPLE_SEARCH_PATH = '/_search'
      def index
        peopleSearch = {
          query: {
            bool: {
              should: should_query
            }
          }
        }
        response = API.make_api_call(PEOPLE_SEARCH_PATH, :get, peopleSearch)
        people = response.body['hits']['hits'].map do |hit|
          hit['_source']
        end
        render json: people
      end

      private

      def ssn
        ssn = params[:search_term].match(/\d{3}-?\d{2}-?\d{4}/)
        if ssn.nil?
          nil
        else
          ssn[0].delete('-')
        end
      end

      def date_of_birth_year
        dates = params[:search_term].match(/\d{4}/)
        if dates.nil?
          nil
        else
          dates[0]
        end
      end

      def date_of_birth_year_month_day
        dates = params[:search_term].match(/\d{4}-\d{2}-\d{2}/)
        if dates.nil?
          nil
        else
          dates[0]
        end
      end

      def date_of_birth_month_day_year
        dates = params[:search_term].match(%r{\d{1,2}\/\d{1,2}\/\d{4}})
        if dates.nil?
          nil
        else
          Date.strptime(dates[0], '%m/%d/%Y').to_s(:db)
        end
      end

      def date_of_birth_query
        query = [date_of_birth_year_month_day, date_of_birth_month_day_year].compact.map do |date|
          { match: { date_of_birth: date } }
        end
        query << { prefix: { date_of_birth: date_of_birth_year } } if date_of_birth_year
        query
      end

      def should_query
        should_query = [
          { match: { first_name: params[:search_term] } },
          { match: { last_name: params[:search_term] } }
        ] | date_of_birth_query
        should_query << { match: { ssn: ssn } } if ssn
        should_query
      end
    end
  end
end
