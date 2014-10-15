class CreateTimelineMessage
  include ActiveModel::Model

  attr_accessor :timeline_id, :student_id, :content

  def save!
    ActiveRecord::Base.transaction do
      create_timeline_message && create_timeline_interaction && sends_pusher_notification
    end
  end

  def timeline_message
    @timeline_message ||= TimelineMessage.new(content: @content, student: student)
  end

  private

    def create_timeline_message
      timeline_message.save
    end

    def create_timeline_interaction
      TimelineInteraction.create(interaction: timeline_message, timeline: timeline)
    end

    def timeline
      @timeline ||= Timeline.where(id: @timeline_id).first!
    end

    def student
      @student ||= Student.where(id: @student_id).first!
    end

    def sends_pusher_notification
      EventPusher.new(timeline.event).student_message(@timeline_message)
    end
end
