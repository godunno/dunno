class TimelineUserMessage < ActiveRecord::Base
  belongs_to :student
  has_one :timeline_interaction, as: :interaction

  acts_as_votable

  validates :content, :student, presence: true

end
