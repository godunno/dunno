class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new logger: Logger

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
      when /index/
        record = Media.find(record_id)
        Client.index  index: 'medias', type: 'media', id: record.id, body: record.as_indexed_json
      when /delete/
        Client.delete index: 'medias', type: 'media', id: record_id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
