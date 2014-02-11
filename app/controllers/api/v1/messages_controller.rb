class Api::V1::MessagesController < ApplicationController
  respond_to :json

  def create
    message_creator = TimelineMessageCreator.new(params[:timeline_user_message])
    if message_creator.save!
      respond_with message_creator.timeline_user_message, location: nil
    else
      render json: message_creator.timeline_user_message.errors, status: :unprocessable_entity
    end
  end
end
