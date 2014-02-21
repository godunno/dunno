class Api::V1::OrganizationsController < Api::V1::ApplicationController
  respond_to :json

  def index
    @organization = Organization.first
    respond_with @organization, root: false
  end
end
