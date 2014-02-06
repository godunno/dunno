class Event < ActiveRecord::Base
  belongs_to :organization
  has_one :timeline

  validates :title, :start_at, presence: true
end
