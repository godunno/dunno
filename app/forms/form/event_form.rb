  class Form::EventForm < Form::Base

    model_class ::Event

    attribute :title, String
    attribute :start_at, DateTime
    attribute :duration, String

    validates :title, :start_at, :duration, presence: true

    def initialize(params = {})
      super(params.slice(:id, :title, :start_at, :duration))
      @topics = populate_children(Form::TopicForm, params[:topics])
      #@thermometers = populate(Form::ThermometerForm, params[:thermometers])
      #@polls = populate(Form::PollForm, params[:polls])
      #@medias = populate(Form::MediaForm, params[:medias])
      #@personal_notes = populate(Form::PersonalNoteForm, params[:personal_notes])
      artifacts.each { |artifact| artifact.timeline = model.timeline }
    end

    def valid?
      result = super
      #[@topics, @thermometers, @polls, @medias, @personal_notes].each do |associateds|
      [@topics].each do |associates|
        associates.each do |associated|
          result &&= associated.valid?
        end
      end
      result
    end

    def errors
      result = super
      artifacts.each do |artifact|
        artifact.errors.each { |error, message| result.add error, message }
      end
      result
    end

    def artifacts
      [@topics, @thermometers, @polls, @medias].compact.flatten
    end

    def event
      @model
    end

    private

      def persist!
        ActiveRecord::Base.transaction do
          @model.title = title
          @model.start_at = start_at
          @model.duration = duration
          @model.save!
          #[@topics, @thermometers, @polls, @medias].each do |artifacts|
          artifacts.each do |artifact|
            artifact.save
          end

          #@personal_notes.each do |personal_note|
          #  personal_note.event = event
          #  personal_note.save!
          #end
        end
      end
  end
