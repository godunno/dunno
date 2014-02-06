class Organization < ActiveRecord::Base
  has_many :events

  validates :name, presence: true

  after_create :set_uuid


  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
