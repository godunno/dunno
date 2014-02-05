class Event < ActiveRecord::Base
  belongs_to :organization

  validates :title, :start_at, presence: true
end
