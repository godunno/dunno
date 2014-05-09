class Api::V1::Teacher::MediasController < Api::V1::TeacherApplicationController
  respond_to :json

  api :PATCH, '/api/v1/teacher/medias/:id/release', "Releases the media on the timeline."
  def release
    if media.status == "available"
      media.release!
      EventPusher.new(media.events.first).release_media(media)
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
