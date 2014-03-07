class Option < ActiveRecord::Base
  belongs_to :poll

  validates :content, presence: true
end
