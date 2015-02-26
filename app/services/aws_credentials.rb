class AwsCredentials

  def encoded_policy
    AwsEncryption.new(policy.strip).encode.gsub("\n", "")
  end

  def signature
    AwsEncryption.new(encoded_policy).encrypt
  end

  def access_key
    ENV["AWS_ACCESS_KEY_ID"]
  end

  def base_url
    "https://#{bucket}.s3.amazonaws.com/"
  end

  private

  def policy
    <<-EOS
{
  "expiration": "2020-01-01T00:00:00Z",
  "conditions": [
    {"bucket": "#{bucket}"},
    ["starts-with", "$key", ""],
    {"acl": "private"},
    ["starts-with", "$Content-Type", ""],
    ["starts-with", "$filename", ""],
    ["content-length-range", 0, 524288000]
  ]
}
    EOS
  end

  def bucket
    ENV["AWS_BUCKET_NAME"]
  end
end
