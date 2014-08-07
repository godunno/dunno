require 'spec_helper'

describe Course do

  let(:course) { build :course }

  describe "associations" do
    it { should belong_to(:teacher) }
    it { should belong_to(:organization) }
    it { should have_many(:events) }
    it { should have_many(:weekly_schedules) }
    it { should have_and_belong_to_many(:students) }
  end

  describe "validations" do
    [:teacher, :start_date, :end_date].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new course" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            course.save!
          end.to change{course.uuid}.from(nil).to(uuid)
        end
      end

      context "existent course" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
          course.save!
        end

        it "does not saves new uuid" do
          SecureRandom.stub(:uuid).and_return("new-uuid-generate-rencently-7cf25d610d4d")
          expect do
            course.save!
          end.to_not change{course.uuid}.from(uuid).to("new-uuid-generate-rencently-7cf25d610d4d")
        end
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
end
