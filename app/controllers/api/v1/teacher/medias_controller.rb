class Api::V1::Teacher::MediasController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    @medias = current_teacher.medias
    @medias = @medias.search(params[:q]).records if params[:q].present?
  end

  def create
    media_params = params[:media].to_h
    media_params[:file] = params[:file]
    media_form = Form::MediaForm.new(media_params.with_indifferent_access)
    media_form.teacher = current_teacher
    if media_form.save
      @media = media_form.model
    else
      render json: { errors: media_form.errors }, status: 422
    end
  end

  def update
    if media.update(media_params)
      render nothing: true, status: 200
    else
      render media.errors, status: 422
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

  def preview
    # TODO: extract to microservice
    # TODO: deal with possible exceptions
    render json: LinkThumbnailer.generate(params[:url])
  end

  private

  def media
    @media ||= Media.where(uuid: params[:id]).first!
  end

  def media_params
    params.require(:media).permit(:title, :tag_list, tag_list: [])
  end
end
