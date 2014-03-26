class Api::V1::SessionsController < Devise::SessionsController

  def create
    @resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, @resource)
    return render "#{resource_name}_sign_in"
  end

  def failure
    return render:json => {:success => false, :errors => ["Login failed."]}, status: 401
  end
end
