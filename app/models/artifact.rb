class Artifact < ActiveRecord::Base

  acts_as_predecessor

  belongs_to :teacher
  has_and_belongs_to_many :events
  has_one :interaction, as: :interaction, class_name: 'TimelineInteraction'
end
