module ElasticsearchWrapper
  def self.client
    return @client if @client
    es_host = if Rails.env.test?
                ENV['TEST_ELASTICSEARCH_URL']
              else
                ENV['ELASTICSEARCH_URL']
              end
    @client = Elasticsearch::Client.new(host: es_host)
  end
end
