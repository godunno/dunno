class AwsFile
  attr_reader :name, :expire_in

  def initialize(name, expire_in = 600)
    @name = URI.decode(name)
    @expire_in = expire_in
  end

  def url
    URI::HTTPS.build(host: host, path: path, query: params.to_query).to_s
  end

  def delete!
    # TODO: implement!
  end

  private

  def canonical_string
    "GET\n\n\n" + expire_at + "\n" + path
  end

  def expire_at
    @expiration_time ||= (Time.current.to_i + expire_in).to_s
  end

  def signature
    AwsEncryption.new(canonical_string).encrypt
  end

  def host
    's3.amazonaws.com'
  end

  def bucket
    ENV["AWS_BUCKET_NAME"]
  end

  def access_key
    ENV["AWS_ACCESS_KEY_ID"]
  end

  def path
    "/#{bucket}/#{name}"
  end

  def params
    { AWSAccessKeyId: access_key, Expires: expire_at, Signature: signature }
  end
end
