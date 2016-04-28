class Dashboard::UsersController < Devise::RegistrationsController
  respond_to :json, :html

  def create
    User.transaction do
      super do |user|
        if user.update(profile: Profile.new)
          TrackerWrapper.new(user).track('User Signed Up')
          create_course_from_template(user) if template_course
        end
      end
    end
  end

  def update
    if current_user.update(update_params)
      sign_in current_user, bypass: true
      render nothing: true, status: 200
    else
      render json: { errors: current_user.errors }, status: 403
    end
  end

  protected

  def update_params
    params.require(:user).permit(:password)
  end

  def template_course
    Course.find_by(id: ENV["TUTORIAL_COURSE_ID"])
  end

  def create_course_from_template(user)
    CreateCourseFromTemplate.new(
      template_course,
      teacher: user.profile,
      weekly_schedules: template_course.weekly_schedules.map(&:dup)
    ).create
  end
end
