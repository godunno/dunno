class Api::V1::CommentsController < Api::V1::ApplicationController
  respond_to :json

  def create
    event = FindOrInitializeEvent.by(course, start_at: event_start_at)
    @comment = event.comments.build(create_params.merge(profile: current_profile))
    authorize @comment

    if @comment.save
      NewCommentNotification.new(@comment, current_profile).deliver
      render
    else
      render json: { errors: @comment.errors }, status: 422
    end
  end

  def destroy
    authorize comment
    comment.update!(removed_at: Time.current)
  end

  def restore
    authorize comment
    comment.update!(removed_at: nil)
  end

  def block
    authorize comment
    comment.update!(blocked_at: Time.current)
  end

  def unblock
    authorize comment
    comment.update!(blocked_at: nil)
  end

  private

  def event_start_at
    Time.zone.parse(params[:comment][:event_start_at])
  end

  def create_params
    params.require(:comment).permit(:body, attachment_ids: [])
  end

  def course
    Course.find_by_identifier!(params[:comment][:course_id])
  end

  def comment
    @comment ||= Comment.find(params[:id])
  end
end
