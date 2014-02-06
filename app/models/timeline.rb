class Timeline < ActiveRecord::Base
  belongs_to :interaction, polymorphic: true
  belongs_to :event

  validates :start_at, presence: true
end
