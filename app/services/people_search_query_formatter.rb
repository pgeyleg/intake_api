# frozen_string_literal: true
class PeopleSearchQueryFormatter # :nodoc:
  attr_reader :search_term

  def initialize(search_term = '')
    @search_term = search_term
  end

  def format_query
    {
      query: {
        bool: {
          should: should_query
        }
      },
      _source: fields,
      highlight: highlight
    }
  end

  private

  def should_query
    should_query = [
      { prefix: { first_name: search_term } },
      { prefix: { last_name: search_term } }
    ] | date_of_birth_query
    should_query << { match: { ssn: ssn } } if ssn
    should_query
  end

  def ssn
    ssn = search_term.match(/\d{3}-?\d{2}-?\d{4}/)
    ssn && ssn[0].delete('-')
  end

  def date_of_birth_year
    dates = search_term.match(/\d{4}/)
    dates && dates[0]
  end

  def date_of_birth_year_month_day
    dates = search_term.match(/\d{4}-\d{2}-\d{2}/)
    dates && dates[0]
  end

  def date_of_birth_month_day_year
    dates = search_term.match(%r{\d{1,2}\/\d{1,2}\/\d{4}})
    dates && Date.strptime(dates[0], '%m/%d/%Y').to_s(:db)
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

  def fields
    %w(
      id first_name middle_name last_name name_suffix gender date_of_birth ssn languages races
      ethnicity addresses.id addresses.street_address addresses.city addresses.state addresses.zip
      addresses.type phone_numbers.id phone_numbers.number phone_numbers.type highlight
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
