class Indexer
  attr_reader :record, :logger

  def initialize(record, logger = Rails.logger)
    @record = record
    @logger = logger
  end

  def index
    client.index index: index_name, type: type, id: id, body: record.as_indexed_json
  end

  def delete
    client.delete index: index_name, type: type, id: id
  end

  private

  def client
    @client ||= Elasticsearch::Client.new logger: logger
  end

  def index_name
    record.class.index_name
  end

  def type
    record.class.name.downcase
  end

  def id
    record.index_id
  end
end
