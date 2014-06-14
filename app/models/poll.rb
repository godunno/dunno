class Poll < ActiveRecord::Base

  include HasUuid

  acts_as_heir_of :artifact

  STATUSES = %w(available released)

  has_many :options

  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }

  accepts_nested_attributes_for :options

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end
end
