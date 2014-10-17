  class Form::EventForm < Form::Base
    model_class ::Event

    attr_accessor :course

    attribute :start_at, Time
    attribute :end_at, Time
    attribute :status, String

    validates :start_at, :end_at, :course, presence: true

    def initialize(params = {})
      super(params.slice(*attributes_list(:start_at, :end_at, :status)))
      self.course = model.course || Course.where(id: params[:course_id]).first
      model.timeline ||= Timeline.new(start_at: start_at)
      @topics = populate_children(Form::TopicForm, params[:topics])
      @thermometers = populate_children(Form::ThermometerForm, params[:thermometers])
      @polls = populate_children(Form::PollForm, params[:polls])
      @medias = populate_children(Form::MediaForm, params[:medias])
      @personal_notes = populate_children(Form::PersonalNoteForm, params[:personal_notes])
      artifacts.each do |artifact|
        artifact.timeline = model.timeline
        artifact.teacher = course.try(:teacher)
      end
      @personal_notes.each { |personal_note| personal_note.event = model }
    end

    def valid?
      result = super
      associates.each do |associated|
        result &&= associated.valid?
      end
      result
    end

    def errors
      result = super
      associates.each do |associated|
        associated.errors.each { |error, message| result.add error, message }
      end
      result
    end

    def artifacts
      [@topics, @thermometers, @polls, @medias].compact.flatten
    end

    def associates
      (artifacts + [@personal_notes]).compact.flatten
    end

    def event
      @model
    end

    private

      def persist!
        model.course = course
        model.start_at = start_at
        model.end_at = end_at
        model.status = status

        ActiveRecord::Base.transaction do
          model.timeline.save!
          model.save!
          associates.each(&:save)
        end
      end

      def parse_time(value)
        value.is_a?(String) ? Time.parse(value) : value
      end
  end
