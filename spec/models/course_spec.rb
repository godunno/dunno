require 'spec_helper'

describe Course do
  subject(:course) { build(:course) }

  describe "associations" do
    it { is_expected.to have_one(:teacher) }
    it { is_expected.to have_many(:students) }
    it { is_expected.to have_many(:moderators) }
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:weekly_schedules) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:tracking_events).dependent(:destroy) }
    it { is_expected.to have_many(:system_notifications).dependent(:destroy) }
  end

  describe "validations" do
    %w(name teacher).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to validate_length_of(:abbreviation).is_at_most(10) }

    it "validates that start date comes before than end date" do
      course.end_date = Time.zone.today
      course.start_date = Time.zone.tomorrow
      expect(course).not_to be_valid
      expect(course.errors.details).to include(start_date: [error: :after_end_date])
    end
  end

  describe "callbacks" do
    describe "after create" do
      context "new course" do
        it "saves a new uuid" do
          expect(course.uuid).to be_nil
          course.save!
          expect(course.uuid).not_to be_nil
        end

        it "saves a new access_code" do
          expect(course.access_code).to be_nil
          course.save!
          expect(course.access_code).not_to be_nil
        end
      end

      context "existent course" do
        before(:each) do
          course.save!
        end

        it "does not saves new uuid" do
          new_uuid = "new-uuid-generate-rencently-7cf25d610d4d"
          allow(SecureRandom).to receive(:uuid).and_return(new_uuid)
          expect do
            course.save!
          end.to_not change { course.uuid }
        end

        it "does not saves new uuid" do
          new_access_code = "ffff"
          allow(SecureRandom).to receive(:hex).and_return(new_access_code)
          expect do
            course.save!
          end.to_not change { course.access_code }
        end
      end
    end
  end

  describe "#order" do
    let(:second_course) { build :course, teacher: course.teacher }
    before do
      course.save!
      second_course.save!
    end

    it { expect(course.order).to eq(1) }
    it { expect(second_course.order).to eq(2) }
  end

  describe "::find_by_identifier!" do
    before do
      course.save!
      create(:course)
    end

    subject { Course.all }

    it { expect(subject.find_by_identifier!(course.uuid)).to eq(course) }
    it { expect(subject.find_by_identifier!(course.access_code)).to eq(course) }

    it "raises error on not found" do
      expect { subject.find_by_identifier!('bla') }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#add_student" do
    before { course.save! }

    let(:student) { create(:profile) }
    context "adding a new student" do
      it { expect { course.add_student(student) }.to change { course.students.size }.by(1)  }

      it "updates the course object" do
        Timecop.travel(Time.now + 10.seconds) do
          expect { course.add_student(student) }
            .to change { course.updated_at.change(usec: 0) }.by_at_least(10)
        end
      end
    end
  end

  describe "#abbreviation" do
    it "should default the abbreviation" do
      course = create :course, name: "Cálculo I", abbreviation: nil
      expect(course.abbreviation).to eq("CI")
    end

    it "should not override the stored abbreviation" do
      abbreviation = "Calc I"
      course = create :course, name: "Cálculo I", abbreviation: abbreviation
      expect(course.abbreviation).to eq(abbreviation)
    end
  end

  context "#active" do
    let!(:finished_course) do
      create(:course, start_date: 2.days.ago, end_date: Time.zone.yesterday)
    end
    let!(:active_course) do
      create(:course, start_date: 2.days.ago, end_date: Time.zone.today)
    end
    let!(:course_without_end_date) do
      create(:course, end_date: nil)
    end

    it { expect(finished_course).to_not be_active }
    it { expect(active_course).to be_active }
    it { expect(course_without_end_date).to be_active }
  end

  describe "memberships" do
    let(:course) { create(:course, teacher: teacher, students: [student], moderators: [moderator]) }
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:moderator) { create(:profile) }

    describe "#teacher" do
      it { expect(course.teacher).to eq(teacher) }
    end

    describe "#students" do
      it { expect(course.students).to eq([student]) }
    end

    describe "#moderators" do
      it { expect(course.moderators).to eq([moderator]) }
    end
  end

  it "knows its color" do
    course.save!
    expect(course.color).to eq SHARED_CONFIG["v1"]["courses"]["schemes"][course.order % 12]
  end
end
