class AwsFile
  attr_reader :key, :expires_at

  def initialize(key, expires_at = 1.day.from_now)
    @key = URI.decode(key)
    @expires_at = expires_at
  end

  def url
    storage.get_object_http_url(bucket, key, expires_at)
  end

  def delete
    storage.delete_object(bucket, key)
  end

  private

  def bucket
    ENV["AWS_BUCKET_NAME"]
  end

  def storage
    @storage ||= Fog::Storage.new(provider: 'AWS', aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
  end
end
