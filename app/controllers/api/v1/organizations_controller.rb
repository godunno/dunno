class Api::V1::OrganizationsController < ApplicationController
  respond_to :json

  def index
    @organization = Organization.first
    respond_with @organization, root: false
  end
end
