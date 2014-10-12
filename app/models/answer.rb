class Answer < ActiveRecord::Base
  belongs_to :student
  belongs_to :option

  validate :validate_uniqueness_per_student_per_poll

  delegate :correct?, to: :option

  private

    def validate_uniqueness_per_student_per_poll
      if Answer.joins(option: :poll).where(student_id: student.id, options: { poll_id: option.poll }).any?
        errors.add :student, :taken
      end
    end
end
