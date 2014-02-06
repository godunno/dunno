class TimelineUserMessage < ActiveRecord::Base
  validates :content, presence: true
end
