class Topic < ActiveRecord::Base

  include HasUuid

  acts_as_heir_of :artifact

  has_many :ratings, as: :rateable

  validates :description, presence: true

  before_create :set_order

  private
    def set_order
      previous = timeline.topics.last.try(:order) || 0
      self.order = previous + 1
    end
end
