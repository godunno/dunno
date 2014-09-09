class Timeline < ActiveRecord::Base
  belongs_to :event
  has_many :timeline_interactions
  has_many :artifacts
  has_many :topics, through: :artifacts, source: :heir, source_type: 'Topic'

  validates :start_at, presence: true

  def interactions
    timeline_interactions.map(&:interaction)
  end
end
