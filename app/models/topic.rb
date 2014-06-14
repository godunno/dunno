class Topic < ActiveRecord::Base

  acts_as_heir_of :artifact

  has_many :ratings, as: :rateable

  validates :description, presence: true

  after_create :set_uuid

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
