class TimelineUserMessage < ActiveRecord::Base
  belongs_to :student
  has_one :timeline_interaction, as: :interaction

  acts_as_votable

  validates :content, :student, presence: true

  after_create :trigger_pusher

  private

    def trigger_pusher
      # TODO: Consertar factory girl para nao ser necessario
      # fazer isso
      if timeline_interaction
        EventPusher.new(timeline_interaction.timeline.event).student_message(content)
      end
    end
end
