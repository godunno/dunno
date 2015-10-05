class Api::V1::CommentsController < Api::V1::ApplicationController
  respond_to :json

  def create
    event = Event.find_by!(start_at: params[:comment][:event_start_at].to_time)
    @comment = event.comments.build(create_params.merge(profile: current_profile))
    authorize @comment

    if @comment.save
      render
    else
      render nothing: true
    end
  end

  private

  def create_params
    params.require(:comment).permit(:body)
  end
end
