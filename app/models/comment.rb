class Comment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :event
  has_many :attachments, dependent: :destroy

  validates :profile, :event, :body, presence: true

  def event_start_at
    event.start_at
  end
end
