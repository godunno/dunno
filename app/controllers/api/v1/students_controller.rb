class Api::V1::StudentsController < ApplicationController
  protect_from_forgery :except => [:login]

  def login
    render json: Student.first
  end
end
