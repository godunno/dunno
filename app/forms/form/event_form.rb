class Form::EventForm < Form::Base
  model_class ::Event

  attr_accessor :course, :topics

  attribute :start_at, Time
  attribute :end_at, Time
  attribute :status, String
  attribute :classroom, String

  validates :start_at, :end_at, :course, presence: true

  def initialize(params = {})
    super(params.slice(*attributes_list(:start_at, :end_at, :classroom)))
    self.status = params[:status] || model.status
    self.course = model.course || Course.where(id: params[:course_id]).first
    @topics = populate_children(Form::TopicForm, params[:topics])
    @medias = populate_children(Form::MediaForm, params[:medias])
    @topics.each { |topic| topic.event = model }
  end

  def valid?
    result = super
    topics.each do |topic|
      result &&= topic.valid?
    end
    result
  end

  def errors
    result = super
    topics.each do |topic|
      topic.errors.each { |error, message| result.add error, message }
    end
    result
  end

  def event
    @model
  end

  private

  def persist!
    model.course    = course
    model.start_at  = start_at
    model.end_at    = end_at
    model.classroom = classroom
    model.status    = status

    ActiveRecord::Base.transaction do
      model.save!
      topics.each(&:save)
    end
  end

  def parse_time(value)
    value.is_a?(String) ? Time.parse(value) : value
  end
end
