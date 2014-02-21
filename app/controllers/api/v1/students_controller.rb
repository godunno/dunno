class Api::V1::StudentsController < Api::V1::ApplicationController
  protect_from_forgery :except => [:login]

  def login
    render json: Student.first, root: false
  end
end
