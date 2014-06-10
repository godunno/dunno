module Form
  class ArtifactForm < Form::Base
    attr_accessor :timeline

    validate :cannot_change_timeline

    private

      def cannot_change_timeline
        if model.timeline.present? && model.timeline != self.timeline
          errors.add :timeline, "can't change Timeline on #{model.inspect}"
        end
      end

    protected

      def persist!
        model.timeline = timeline
      end
  end
end

