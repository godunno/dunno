require 'spec_helper'

describe Course do

  let(:course) { build :course }

  describe "associations" do
    it { should belong_to(:teacher) }
    it { should belong_to(:organization) }
    it { should have_many(:events) }
    it { should have_and_belong_to_many(:students) }
  end

  describe "validations" do
    [:teacher].each do |attr|
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

  shared_examples "time of day" do |attribute|

    before do
      course.send("#{attribute}=", '2:30')
      course.save!
    end

    subject { course.reload }

    its(attribute) { should be_a TimeOfDay }
    its(attribute) { should eq TimeOfDay.new(2, 30) }
  end

  [:start_time, :end_time].each do |attribute|
    it_behaves_like "time of day", attribute
  end

  describe "#weekdays" do

    let(:weekdays) { %w(1 3) }

    before do
      course.weekdays = weekdays
      course.save!
    end

    subject { course.reload }

    its(:weekdays) { should be_an Array }
    its(:weekdays) { should eq weekdays }
  end
end
