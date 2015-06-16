
def auth_params(model = nil)
  model = create(:profile) unless model
  { "user_email" => model.email, "user_token" => model.authentication_token }
end
