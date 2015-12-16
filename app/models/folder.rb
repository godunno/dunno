class Folder < ActiveRecord::Base
  belongs_to :course
  has_many :medias

  validates :name, :course, presence: true
end
