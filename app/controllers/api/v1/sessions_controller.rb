class Api::V1::SessionsController < Devise::SessionsController

  api :POST, '/api/v1/users/sign_in', "Sign in to the system and get the user's data. Don't forget to store the authentication token."
  def create
    @resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    profile_name = @resource.profile.class.name.downcase
    return render "#{profile_name}_sign_in"
  end
end
