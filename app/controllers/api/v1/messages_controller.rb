class Api::V1::MessagesController < Api::V1::StudentApplicationController
  respond_to :json

  def create
    if timeline.event.closed?
      return render json: { errors: I18n.t('errors.event.closed') }, status: 403
    end
    message_creator = TimelineMessageCreator.new(params[:timeline_user_message])
    if message_creator.save!
      respond_with message_creator.timeline_user_message, location: nil
    else
      render json: { errors: message_creator.timeline_user_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def up
    if message.timeline.event.closed?
      return render json: { errors: I18n.t('errors.event.closed') }, status: 403
    end
    message.up_by(student)
    EventPusher.new(message.timeline.event).up_down_vote_message(message)
    render json: "{}", status: 200
  end

  def down
    message.down_by(student)
    EventPusher.new(message.timeline.event).up_down_vote_message(message)
    render json: "{}", status: 200
  end

  private

    def timeline
      @timeline ||= Timeline.find(params[:timeline_user_message][:timeline_id])
    end

    def message
      @message ||= TimelineUserMessage.find(params[:id])
    end

    def student
      Student.find(params[:student_id])
    end
end
