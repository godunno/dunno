class Api::V1::StudentsController < Api::V1::ApplicationController
  protect_from_forgery :except => [:login]
  skip_before_filter :authenticate_student_from_token!

  def login
    render json: Student.first, root: false
  end
end
