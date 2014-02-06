class TimelineUserMessage < ActiveRecord::Base
  belongs_to :timeline

  validates :content, presence: true
end
