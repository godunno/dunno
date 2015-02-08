class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    @resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    render "#{@resource.profile_name}_sign_in"
  end

  def profile
    @resource = current_user
    render "#{@resource.profile_name}_sign_in"
  end
end
