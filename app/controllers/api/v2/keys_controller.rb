class Api::V2::KeysController < Api::V2::ApplicationController
  before_action :authenticate_user_with_credentials!, only: :create
  def create
    @token = current_user.api_keys.create.token
  end
end
