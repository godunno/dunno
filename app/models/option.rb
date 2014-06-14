class Option < ActiveRecord::Base
  include HasUuid
  belongs_to :poll

  validates :content, presence: true
end
