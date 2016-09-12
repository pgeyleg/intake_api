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
    mapping do
      indexes :first_name
      indexes :last_name
      indexes :gender
      indexes :ssn
      indexes :date_of_birth
    end
  end

  def serialize(document)
    document.attributes
  end

  def deserialize(document)
    document['_source']
  end
end
