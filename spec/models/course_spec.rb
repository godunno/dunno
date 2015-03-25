require 'spec_helper'

describe Course do

  let(:course) { build :course }

  describe "associations" do
    it { is_expected.to belong_to(:teacher) }
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:weekly_schedules) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_and_belong_to_many(:students) }
  end

  describe "validations" do
    [:teacher, :start_date, :end_date, :abbreviation].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it { is_expected.to validate_length_of(:abbreviation).is_at_most(10) }
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

    describe "after validation" do
      it "abbreviate name" do
        course = create :course, name: "Cálculo I", abbreviation: nil
        expect(course.abbreviation).to eq("CI")
      end
    end
  end

  describe "#channel" do
    before do
      course.save!
    end

    it { expect(course.channel).to eq("course_#{course.uuid}") }
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
    before { course.save! }

    it { expect(Course.find_by_identifier!(course.uuid)).to eq(course) }
    it { expect(Course.find_by_identifier!(course.access_code)).to eq(course) }

    it "raises error on not found" do
      expect { Course.find_by_identifier!('bla') }
      .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".add_student" do
    before { course.save! }

    let(:student) { create(:student) }
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
end
