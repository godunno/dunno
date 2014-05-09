class Thermometer < ActiveRecord::Base

  acts_as_heir_of :artifact

  has_many :ratings, as: :rateable

  validates :content, presence: true

  after_create :set_uuid

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
