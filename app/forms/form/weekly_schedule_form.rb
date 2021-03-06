class Form::WeeklyScheduleForm < Form::Base
  model_class ::WeeklySchedule

  attr_accessor :course

  attribute :start_time, String
  attribute :end_time, String
  attribute :weekday, Integer
  attribute :classroom, String

  validates :weekday, presence: true

  def initialize(params = {})
    super(params.slice(*attributes_list(
      :start_time, :end_time, :weekday, :classroom
    )))
    self.course = Course.find_by(uuid: params[:course_id])
  end

  private

  def persist!
    model.start_time = start_time
    model.end_time = end_time
    model.weekday = weekday
    model.classroom = classroom
    model.course = course

    model.save!
  end
end
