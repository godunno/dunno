class Poll < ActiveRecord::Base
  belongs_to :event
  has_many :options

  validates :content, presence: true

  accepts_nested_attributes_for :options
end
