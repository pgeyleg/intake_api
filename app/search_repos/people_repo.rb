# frozen_string_literal: true
require "#{Rails.root}/lib/elasticsearch_wrapper"

# PeopleRepo is the Repository object for accessing People ES index
class PeopleRepo
  include Elasticsearch::Persistence::Repository

  def initialize(options = {})
    index options[:index] || 'people'
    client ::ElasticsearchWrapper.client
  end

  klass Person

  settings do
    mappings dynamic: 'strict' do
      indexes :id
      indexes :first_name
      indexes :middle_name
      indexes :last_name
      indexes :name_suffix
      indexes :gender
      indexes :ssn
      indexes :date_of_birth
      indexes :languages
      indexes :races do
        indexes :race
        indexes :race_detail
      end
      indexes :ethnicity do
        indexes :hispanic_latino_origin
        indexes :ethnicity_detail
      end
      indexes :addresses do
        indexes :id
        indexes :street_address
        indexes :city
        indexes :state
        indexes :zip
        indexes :type
      end
      indexes :phone_numbers do
        indexes :id
        indexes :number
        indexes :type
      end
    end
  end

  def serialize(document)
    PersonSerializer.new(document).as_json
  end

  def deserialize(document)
    document['_source']
  end
end
