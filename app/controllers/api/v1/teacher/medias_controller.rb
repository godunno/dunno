class Api::V1::Teacher::MediasController < Api::V1::TeacherApplicationController
  respond_to :json

  def release
    if media.status == "available"
      media.update(status: "released")
      EventPusher.new(media.event).release_media(media)
      render json: "{}", status: 200
    else
      render json: { errors: [I18n.t('errors.already_released')] }, status: 400
    end
  end

  private
    def media
      @media ||= Media.where(uuid: params[:id]).first!
    end
end
