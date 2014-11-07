class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token

  validates :token, presence: true, on: :update
  validates :user, presence: true

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex
      break unless self.class.exists?(token: token)
    end
  end
end
