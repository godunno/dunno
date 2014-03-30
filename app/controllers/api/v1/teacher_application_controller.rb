class Api::V1::TeacherApplicationController < ActionController::Base
  before_filter :authenticate_teacher_from_token!
  before_filter :authenticate_teacher!

  private

    # Solution given on:
    # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
    def authenticate_teacher_from_token!
      teacher_email = params[:teacher_email].presence
      teacher       = teacher_email && Teacher.find_by_email(teacher_email)

      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      if teacher && Devise.secure_compare(teacher.authentication_token, params[:teacher_token])
        sign_in teacher, store: false
      end
    end
end
