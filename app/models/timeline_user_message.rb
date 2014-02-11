class TimelineUserMessage < ActiveRecord::Base
  belongs_to :student

  acts_as_votable

  validates :content, presence: true
end
