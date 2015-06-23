class User < ActiveRecord::Base
  include HasUuid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :async

  belongs_to :profile, dependent: :destroy
  has_many :api_keys, dependent: :destroy

  validates :name, :phone_number, presence: true

  before_save :ensure_authentication_token

  def profile_name
    profile.memberships.where(role: 'teacher').any? ? 'teacher' : 'student'
  end

  private

    def ensure_authentication_token
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
