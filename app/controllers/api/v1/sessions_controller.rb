class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    @resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    TrackerWrapper.new(@resource).track('User Signed In')
    render :user_sign_in
  end

  def profile
    @resource = current_user
    if @resource.present?
      render :user_sign_in
    else
      render nothing: true, status: 401
    end
  end
end
