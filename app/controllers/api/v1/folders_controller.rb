class Api::V1::FoldersController < Api::V1::ApplicationController
  respond_to :json

  def index
    @folders = course.folders
  end

  def show
    skip_authorization
    folder
  end

  def create
    @folder = course(params[:folder]).folders.build(folder_params)
    authorize @folder
    @folder.save!
  end

  def destroy
    authorize folder
    folder.destroy!
    render nothing: true
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end

  def folder
    @folder ||= Folder.where(course: current_profile.courses).find(params[:id])
  end

  def course(scope = params)
    @course ||= current_profile.courses.find_by_identifier!(scope[:course_id])
  end
end

