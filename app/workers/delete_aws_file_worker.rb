class DeleteAwsFileWorker
  include Sidekiq::Worker
  sidekiq_options queue: 's3'

  def perform(file_url)
    logger.debug ["deleting aws file", "File URL: #{file_url}"]
    AwsFile.new(file_url).delete
  end
end
