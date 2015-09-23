class User < ActiveRecord::Base
  include HasUuid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :async

  belongs_to :profile, dependent: :destroy
  has_many :api_keys, dependent: :destroy

  validates :name, presence: true

  before_save :ensure_authentication_token

  def profile_name
    profile.memberships.where(role: 'teacher').any? ? 'teacher' : 'student'
  end

  def send_reset_password_instructions_notification(*args)
    super
    track('Reset Password Requested')
  end

  def reset_password(*args)
    return unless super
    track('Password Changed', page: "Password Recovery")
  end

  private

  def track(message, options = {})
    @tracker ||= TrackerWrapper.new(self)
    @tracker.track(message, options)
  end

  def ensure_authentication_token
    return if authentication_token.present?
    self.authentication_token = generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
