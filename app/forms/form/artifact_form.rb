module Form
  class ArtifactForm < Form::Base
    attr_accessor :timeline
    attr_accessor :teacher

    validate :cannot_change_timeline

    private

      def cannot_change_timeline
        if model.timeline.present? && model.timeline != timeline
          errors.add :timeline, "can't change Timeline on #{model.inspect}"
        end
      end

    protected

      def persist!
        model.timeline = timeline
        model.teacher = teacher
      end
  end
end
