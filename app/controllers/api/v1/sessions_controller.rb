class Api::V1::SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
    return render :json => StudentSerializer.new(resource).as_json(root: false).
      merge({:success => true, authentication_token: resource.authentication_token })
  end

  def failure
    return render:json => {:success => false, :errors => ["Login failed."]}, status: 401
  end
end
