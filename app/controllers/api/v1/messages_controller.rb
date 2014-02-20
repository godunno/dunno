class Api::V1::MessagesController < ApplicationController
  respond_to :json

  def create
    message_creator = TimelineMessageCreator.new(timeline_id: params[:timeline_id], student_id:params[:student_id], content:params[:content])
    if message_creator.save!
      respond_with message_creator.timeline_user_message, location: nil
    else
      render json: { errors: message_creator.timeline_user_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def up
    message.up_by(student)
    EventPusher.new(message.timeline.event).up_down_vote_message(message.up_votes.count, message.down_votes.count)
    render nothing: true, status: 200
  end

  def down
    message.down_by(student)
    EventPusher.new(message.timeline.event).up_down_vote_message(message.up_votes.count, message.down_votes.count)
    render nothing: true, status: 200
  end

  private
    def message
      @message ||= TimelineUserMessage.find(params[:id])
    end

    def student
      Student.find(params[:student_id])
    end
end
