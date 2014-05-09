class Api::V1::AnswersController < Api::V1::StudentApplicationController
  respond_to :json

  api :POST, '/api/v1/answers', "Creates an answer for the indicated poll"
  def create
    if option.poll.events.first.closed?
      return render json: { errors: I18n.t('errors.event.closed') }, status: 403
    end
    answer = Answer.new
    answer.student = current_student
    answer.option = option
    answer.save
    render json: "{}", status: 201
  end

  private
    def option
      @option ||= Option.where(uuid: params[:option_id]).first!
    end
end
