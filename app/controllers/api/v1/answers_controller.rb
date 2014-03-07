class Api::V1::AnswersController < Api::V1::ApplicationController
  respond_to :json

  def create
    answer = Answer.new
    answer.student = current_student
    answer.option = option
    answer.save
    render nothing: true, status: 201
  end

  private
    def option
      @option ||= Option.where(uuid: params[:option_id]).first!
    end
end
