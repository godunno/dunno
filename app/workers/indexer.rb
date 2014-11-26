# https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model#asynchronous-callbacks

class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  LOGGER = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  CLIENT = Elasticsearch::Client.new logger: LOGGER

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when "index"
      record = Media.find(record_id)
      CLIENT.index index: 'medias', type: 'media', id: record.id, body: record.as_indexed_json
    when "delete"
      CLIENT.delete index: 'medias', type: 'media', id: record_id
    else fail ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
