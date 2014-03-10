class Poll < ActiveRecord::Base

  STATUSES = %w(available released)

  belongs_to :event
  has_many :options

  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }

  after_create :set_uuid

  accepts_nested_attributes_for :options

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
