class Api::V1::OrganizationsController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @organization = Organization.first
    respond_with @organization
  end
end
