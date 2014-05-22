class Timeline < ActiveRecord::Base
  belongs_to :event
  has_many :timeline_interactions
  has_many :artifacts

  validates :start_at, presence: true

  def interactions
    timeline_interactions.map(&:interaction)
  end
end
