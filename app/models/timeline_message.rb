class TimelineMessage < ActiveRecord::Base
  belongs_to :student
  has_one :timeline_interaction, as: :interaction
  has_one :timeline, through: :timeline_interaction

  acts_as_votable

  validates :content, :student, presence: true

end
