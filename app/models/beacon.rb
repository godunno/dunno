class Beacon < ActiveRecord::Base
  include HasUuid

  has_many :events

  validates :title, presence: true
  validates :minor, presence: true
  validates :major, presence: true
end
