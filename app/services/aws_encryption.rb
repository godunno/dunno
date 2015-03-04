class AwsEncryption
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def encrypt
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha1"), secret_key, data)
    URI.escape(AwsEncryption.new(hmac).encode)
  end

  def encode
    Base64.encode64(data).strip
  end

  private

  def secret_key
    ENV["AWS_SECRET_ACCESS_KEY"]
  end
end
