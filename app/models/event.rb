class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :timelines

  validates :title, :start_at, presence: true
end
