class Folder < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :medias

  validates :name, :course, presence: true
end
