class Beacon < ActiveRecord::Base
  has_many :events

  validates :title, presence: true
  validates :minor, presence: true
  validates :major, presence: true

  after_create :set_uuid

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
