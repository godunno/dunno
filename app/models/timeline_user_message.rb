class TimelineUserMessage < ActiveRecord::Base

  acts_as_votable

  validates :content, presence: true
end
