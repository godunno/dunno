class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :courses
  has_many :events, through: :courses

  validates :name, :phone_number, presence: true
  validates :phone_number, format: { with: /\A\+55 \d{2} \d{4,5} \d{4}\z/ }

  before_save :ensure_authentication_token

  private
    def ensure_authentication_token
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless Student.where(authentication_token: token).first
      end
    end
end
