# https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model#asynchronous-callbacks

class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  def perform(model_class, operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when "index"
      Indexer.new(model_class.constantize.find(record_id), logger).index
    when "delete"
      Indexer.new(model_class.constantize.new(id: record_id), logger).delete
    else fail ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
