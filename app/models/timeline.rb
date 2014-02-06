class Timeline < ActiveRecord::Base
  belongs_to :event

  validates :start_at, presence: true
end
