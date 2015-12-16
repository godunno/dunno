class Api::V1::FoldersController < Api::V1::ApplicationController
  respond_to :json

  def index
    @folders = course.folders
  end

  def create
    @folder = Folder.new(folder_params)
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
    params.require(:folder).permit(:name, :course_id)
  end

  def folder
    @folder ||= Folder.where(course: current_profile.courses).find(params[:id])
  end

  def course
    @course ||= Course.find(params[:course_id])
  end
end

