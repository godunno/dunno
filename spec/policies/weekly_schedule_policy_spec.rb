require 'spec_helper'
require 'pundit/rspec'

describe WeeklySchedulePolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:weekly_schedule) { create(:weekly_schedule, course: course) }

  subject { described_class }

  permissions :transfer? do
    it { is_expected.to permit(teacher, weekly_schedule) }
    it { is_expected.not_to permit(student, weekly_schedule) }
    it { is_expected.not_to permit(anyone, weekly_schedule) }
  end

  permissions :create? do
    it { is_expected.to permit(teacher, WeeklySchedule.new(course: course)) }
    it { is_expected.not_to permit(student, WeeklySchedule.new(course: course)) }
    it { is_expected.not_to permit(anyone, WeeklySchedule.new(course: course)) }
  end

  permissions :destroy? do
    it { is_expected.to permit(teacher, weekly_schedule) }
    it { is_expected.not_to permit(student, weekly_schedule) }
    it { is_expected.not_to permit(anyone, weekly_schedule) }
  end
end
