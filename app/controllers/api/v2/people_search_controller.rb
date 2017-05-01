# frozen_string_literal: true

# PeopleSearchController is the controller responsible for accessing People ES index
module Api
  module V2
    class PeopleSearchController < ApplicationController # :nodoc:
      include AuthenticationConcern

      PEOPLE_SEARCH_PATH = '/api/v1/dora/people/_search'
      def index
        people_search = {
          query: {
            bool: {
              should: should_query
            }
          },
          _source: fields,
          highlight: highlight
        }
        response = API.make_api_call(PEOPLE_SEARCH_PATH, :post, people_search)
        people = response.body['hits']['hits'].map do |document|
          person_with_highlights(document)
        end
        render json: people
      end

      private

      def person_with_highlights(document)
        highlight = {}
        if document['highlight']
          highlight = document['highlight'].each_with_object({}) do |(k, v), memo|
            memo[k] = v.first
            memo
          end
        end
        document['_source'].merge(highlight: highlight)
      end

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

        birth_year = date_of_birth_year
        if birth_year
          birth_year_query = {
            range: {
              date_of_birth: {
                gte: "#{birth_year}||/y",
                lte: "#{birth_year}||/y",
                format: 'yyyy'
              }
            }
          }
          query << birth_year_query
        end

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

      def fields
        %w(
          id first_name middle_name last_name name_suffix gender
          date_of_birth ssn languages races ethnicity
          addresses.id addresses.street_address
          addresses.city addresses.state addresses.zip addresses.type
          phone_numbers.id phone_numbers.number phone_numbers.type
          highlight
        )
      end

      def highlight
        {
          order: 'score',
          number_of_fragments: 3,
          require_field_match: true,
          fields: {
            first_name: {},
            last_name: {},
            date_of_birth: {},
            ssn: {}
          }
        }
      end
    end
  end
end
