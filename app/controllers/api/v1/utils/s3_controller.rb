class Api::V1::Utils::S3Controller < Api::V1::ApplicationController
  def credentials
    cred = AwsCredentials.new
    render json: { access_key: cred.access_key, signature: cred.signature, policy: cred.encoded_policy, base_url: cred.base_url }
  end
end
