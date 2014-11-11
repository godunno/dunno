module AuthRequestHelpers
  def sign_in(user)
    token = ActionController::HttpAuthentication::Token
      .encode_credentials(user.api_keys.first.token)
    header "Authorization", token
  end

  def sign_in_with_http_basic(user)
    http_basic_hash = ActionController::HttpAuthentication::Basic
      .encode_credentials(user.email, user.password)
    header "Authorization", http_basic_hash
  end
end
