
def auth_params(model = :student)
  unless model.is_a? ActiveRecord::Base
    model = create(model)
  end
  name = model.class.name.downcase
  { "#{name}_email" => model.email, "#{name}_token" => model.authentication_token }
end
