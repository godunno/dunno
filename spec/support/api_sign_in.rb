
def auth_params(model = :student)
  unless model.is_a? ActiveRecord::Base
    model = create(model)
  end
  { "user_email" => model.email, "user_token" => model.authentication_token }
end
