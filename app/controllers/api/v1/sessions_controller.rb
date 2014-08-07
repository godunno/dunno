class Api::V1::SessionsController < Devise::SessionsController

  api :POST, '/api/v1/students/sign_in', "Sign in to the system and get the user's data. Don't forget to store the authentication token."
  def create
    binding.pry
    @resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    return render "#{resource_name}_sign_in"
  end

  def failure
    return render:json => {:success => false, :errors => ["Login failed."]}, status: 401
  end
end
