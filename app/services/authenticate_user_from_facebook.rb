class AuthenticateUserFromFacebook
  def initialize(omniauth_hash)
    @facebook_uid = omniauth_hash.uid
    @user_info = omniauth_hash.info
  end

  def authenticate
    (find_user_by_email || find_or_create_user_by_facebook_uid).tap do |user|
      user.update(facebook_uid: facebook_uid, avatar_url: user_info.image)
    end
  end

  private

  attr_reader :facebook_uid, :user_info

  def find_user_by_email
    User.find_by(email: user_info.email)
  end

  def find_or_create_user_by_facebook_uid
    User.find_or_initialize_by(facebook_uid: facebook_uid) do |u|
      u.name = user_info.name
      u.email = user_info.email
      u.password = Devise.friendly_token[0, 20]
    end
  end
end
