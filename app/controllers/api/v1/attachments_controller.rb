class Api::V1::AttachmentsController < Api::V1::ApplicationController
  respond_to :json

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.profile = current_profile
    authorize @attachment
    @attachment.save!
  end

  def destroy
    attachment = Attachment.find(params[:id])
    authorize attachment
    attachment.destroy!
    render nothing: true
  end

  private

  def attachment_params
    params.require(:attachment).permit(:original_filename, :file_url, :file_size)
  end
end
