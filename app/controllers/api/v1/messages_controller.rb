class Api::V1::MessagesController < ApplicationController
  respond_to :json

  def create
    message_creator = TimelineMessageCreator.new(params[:timeline_user_message])
    if message_creator.save!
      respond_with message_creator.timeline_user_message, location: nil
    else
      render json: { errors: message_creator.timeline_user_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def up
    message = TimelineUserMessage.find(params[:id])
    message.up_by(Student.find(params[:student_id]))
    EventPusher.new(message.timeline.event).up_down_vote_message(message.up_votes.count, message.down_votes.count)
    render nothing: true, status: 200
  end

  def down
    message = TimelineUserMessage.find(params[:id])
    message.down_by(Student.find(params[:student_id]))
    EventPusher.new(message.timeline.event).up_down_vote_message(message.up_votes.count, message.down_votes.count)
    render nothing: true, status: 200
  end
end
