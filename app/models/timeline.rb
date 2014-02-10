class Timeline < ActiveRecord::Base
  belongs_to :event
  has_many :timeline_interactions

  validates :start_at, presence: true

  def interactions
    []
  end
end
