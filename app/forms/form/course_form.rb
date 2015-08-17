module Form
  class CourseForm < Form::Base
    model_class ::Course

    attribute :name, String
    attribute :start_date, Date
    attribute :end_date, Date
    attribute :class_name, String
    attribute :grade, String
    attribute :institution, String
    attribute :teacher

    validates :name, presence: true

    def initialize(params = {})
      super(params.slice(*attributes_list(
        :name, :start_date, :end_date, :class_name, :grade, :institution
      )))
      self.teacher = params[:teacher]
      @weekly_schedules = populate_children(
        Form::WeeklyScheduleForm, params[:weekly_schedules]
      )
    end

    def valid?
      result = super
      @weekly_schedules.each do |weekly_schedule|
        result &&= weekly_schedule.valid?
      end
      result
    end

    def errors
      result = super
      @weekly_schedules.each do |weekly_schedule|
        weekly_schedule.errors.each { |error, message| result.add error, message }
      end
      result
    end

    private

    def persist!
      CourseEventsIndexerWorker.perform_async(model.id) if should_index_events?
      PersistPastEvents.new(model).persist! if should_persist_past_events?
      model.teacher = teacher
      model.name = name
      model.start_date = start_date
      model.end_date = end_date
      model.class_name = class_name
      model.grade = grade
      model.institution = institution
      ActiveRecord::Base.transaction do
        model.save!
        @weekly_schedules.each do |weekly_schedule|
          weekly_schedule.course = model
          weekly_schedule.save
        end
      end
    end

    def should_index_events?
      model.persisted? &&
        (start_date != model.start_date || end_date != model.end_date)
    end

    def should_persist_past_events?
      start_date &&
        model.start_date && start_date < model.start_date
    end
  end
end
