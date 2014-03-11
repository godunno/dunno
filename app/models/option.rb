class Option < ActiveRecord::Base
  belongs_to :poll

  validates :content, presence: true

  after_create :set_uuid

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
