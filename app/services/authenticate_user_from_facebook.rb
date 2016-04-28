class AuthenticateUserFromFacebook
  def initialize(omniauth_hash)
    @facebook_uid = omniauth_hash.uid
    @user_info = omniauth_hash.info
  end

  def authenticate
    user = (find_user_by_email || find_or_initialize_user_by_facebook_uid)
    create_course_from_template(user) if user.new_record? && template_course
    user.update(facebook_uid: facebook_uid, avatar_url: user_info.image) && user
  end

  private

  attr_reader :facebook_uid, :user_info

  def find_user_by_email
    User.find_by(email: user_info.email)
  end

  def find_or_initialize_user_by_facebook_uid
    User.find_or_initialize_by(facebook_uid: facebook_uid) do |u|
      u.name = user_info.name
      u.email = user_info.email
      u.password = Devise.friendly_token[0, 20]
      u.profile = Profile.new
    end
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
