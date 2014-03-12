class Answer < ActiveRecord::Base
  belongs_to :student
  belongs_to :option

  validate :validate_uniqueness_per_student_per_poll

  private
    def validate_uniqueness_per_student_per_poll
      if Answer.joins(option: :poll).where(student: student, options: { poll_id: option.poll }).any?
        errors.add :student, :taken
      end
    end
end
