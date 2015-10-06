class Api::V1::CommentsController < Api::V1::ApplicationController
  respond_to :json

  def create
    event = Event.find_by!(start_at: event_start_at)
    @comment = event.comments.build(create_params.merge(profile: current_profile))
    authorize @comment

    if @comment.save
      render
    else
      render json: { errors: @comment.errors }, status: 422
    end
  end

  private

  def event_start_at
    Time.zone.parse(params[:comment][:event_start_at])
  end

  def create_params
    params.require(:comment).permit(:body, attachment_ids: [])
  end
end
