# https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model#asynchronous-callbacks

class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  def client
    @client ||= Elasticsearch::Client.new logger: logger
  end

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when "index"
      Indexer.new(Media.find(record_id)).index
    when "delete"
      Indexer.new(Media.new(id: record_id)).delete
    else fail ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
