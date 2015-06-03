class Api::V1::MediasController < Api::V1::ApplicationController
  respond_to :json

  def index
    @result = Media.search(media_search_params.merge(
      filter: {
        profile_id: current_profile.id
      }
    ))
  end

  def create
    media_form = Form::MediaForm.new(media_create_params)
    media_form.profile = current_profile
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

  def destroy
    media.destroy
    render nothing: true
  end

  private

  def media
    @media ||= current_profile.medias.find_by!(uuid: params[:id])
  end

  def media_params
    params.require(:media).permit(:title, :tag_list, tag_list: [])
  end

  def media_search_params
    params.permit(:page, :q, :per_page)
  end

  def media_create_params
    params.require(:media).permit(:url, :file_url, :original_filename)
  end
end