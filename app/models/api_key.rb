class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token

  validates :token, presence: true, on: :update
  validates :user, presence: true

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end

class ApiKey < ActiveRecord::Base
  def to_param
    token
  end

  private

end
