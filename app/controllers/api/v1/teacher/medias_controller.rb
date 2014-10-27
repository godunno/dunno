class Api::V1::Teacher::MediasController < Api::V1::TeacherApplicationController
  respond_to :json

  def create
    @media_form = Form::MediaForm.new(params[:media])
    if @media_form.save
      render json: { id: @media_form.model.id }, status: 200
    else
      render json: { errors: @media_form.errors }, status: 422
    end
  end

  api :PATCH, '/api/v1/teacher/medias/:id/release', "Releases the media on the timeline."
  def release
    if media.status == "available"
      media.release!
      EventPusher.new(media.event).release_media(media)
      render json: "{}", status: 200
    else
      render json: { errors: [I18n.t('errors.already_released')] }, status: 304
    end
  end

  private

    def media
      @media ||= Media.where(uuid: params[:id]).first!
    end
end
