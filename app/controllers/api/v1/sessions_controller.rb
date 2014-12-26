class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  api :POST, '/api/v1/users/sign_in', "Sign in to the system and get the user's data. Don't forget to store the authentication token."
  def create
    @resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    render "#{profile_name}_sign_in"
  end

  def profile
    @resource = current_user
    render "#{profile_name}_sign_in"
  end

  private

  def profile_name
    @resource.profile.class.name.downcase
  end
end
