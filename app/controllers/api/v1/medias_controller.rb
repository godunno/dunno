class Api::V1::MediasController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    @result = Media.search(media_search_params.merge(
      filter: {
        course_uuid: params[:course_uuid]
      }
    ))
  end

  private

  def media_search_params
    params.permit(:page, :q, :per_page)
  end
end
