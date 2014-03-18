class Organization < ActiveRecord::Base

  has_many :events
  has_many :courses
  has_and_belongs_to_many :teachers

  validates :name, presence: true

  after_create :set_uuid


  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
