class Notification < ActiveRecord::Base

  belongs_to :course

  validates :course, presence: true
  validates :message, presence: true, length: { in: 1..160 }, format: { with: /\A\[Dunno\]/ }

end
