class Comment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :event

  validates :profile, :event, :body, presence: true

  def event_start_at
    event.start_at
  end
end
