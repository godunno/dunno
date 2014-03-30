class Api::V1::StudentApplicationController < ActionController::Base
  before_filter :authenticate_student_from_token!
  before_filter :authenticate_student!

  private

    # Solution given on:
    # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    def authenticate_student_from_token!
      student_email = params[:student_email].presence
      student       = student_email && Student.find_by_email(student_email)

      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      if student && Devise.secure_compare(student.authentication_token, params[:student_token])
        sign_in student, store: false
      end
    end
end
