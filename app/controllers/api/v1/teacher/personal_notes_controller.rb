class Api::V1::Teacher::PersonalNotesController < Api::V1::TeacherApplicationController
  respond_to :json

  def transfer
    next_event = personal_note.event.next
    if next_event
      personal_note.update!(event: next_event)
      status = 200
    else
      status = 422
    end
    render nothing: true, status: status
  end

  private

    def personal_note
      @personal_note ||= PersonalNote.find_by!(uuid: params[:id])
    end
end
