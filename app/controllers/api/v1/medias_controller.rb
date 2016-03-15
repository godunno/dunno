class Api::V1::MediasController < Api::V1::ApplicationController
  respond_to :json

  def index
    @result = if params[:course_uuid].present?
                course = current_profile
                         .courses
                         .find_by_identifier!(params[:course_uuid])
                Media.search_by_course(course, media_search_params)
              elsif params[:folder_id].present?
                folder = Folder.where(course: current_profile.courses).find(params[:folder_id])
                Media.search_by_folder(folder, media_search_params)
              else
                Media.search_by_profile(current_profile, media_search_params)
              end
  end

  def create
    media_form = Form::MediaForm.new(media_create_params)
    media_form.profile = current_profile
    authorize media_form
    if media_form.save
      @media = media_form.model
    else
      render json: { errors: media_form.errors }, status: 422
    end
  end

  def update
    media.attributes = media_params
    authorize media
    if media.save
      render nothing: true, status: 200
    else
      render media.errors, status: 422
    end
  end

  def destroy
    authorize media
    media.destroy
    render nothing: true
  end

  def show
    authorize media(Media.all)
    TrackEvent::MediaAccessed.new(media(Media.all), current_profile).track
    render nothing: true
  end

  private

  def media(scope = current_profile.medias)
    @media ||= scope.find_by!(uuid: params[:id])
  end

  def media_params
    params.require(:media).permit(:title, :tag_list, :folder_id, tag_list: [])
  end

  def media_search_params
    params.permit(:page, :q, :per_page)
  end

  def media_create_params
    params.require(:media).permit(:url, :file_url, :original_filename)
  end
end
