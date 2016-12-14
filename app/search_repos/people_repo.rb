# frozen_string_literal: true

# PeopleRepo is the Repository object for accessing People ES index
class PeopleRepo
  include Elasticsearch::Persistence::Repository

  def initialize(options = {})
    index options[:index] || 'people'
    es_host = if Rails.env.test?
                ENV['TEST_ELASTICSEARCH_URL']
              else
                ENV['ELASTICSEARCH_URL']
              end
    client Elasticsearch::Client.new(host: es_host)
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
      indexes :address do
        indexes :id
        indexes :street_address
        indexes :city
        indexes :state
        indexes :zip
        indexes :type
      end
      indexes :created_at
      indexes :updated_at
    end
  end

  def serialize(document)
    PersonSerializer.new(document).as_json.except(:phone_numbers)
  end

  def deserialize(document)
    document['_source']
  end
end
