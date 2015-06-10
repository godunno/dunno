require 'spec_helper'

describe Event do

  let(:event) { build(:event) }

  describe "associations" do
    it { is_expected.to belong_to(:course).touch(true) }
    it { is_expected.to have_many(:topics) }
  end

  describe "validations" do

    %w(start_at end_at course).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do
      context "new event" do
        it "saves a new uuid" do
          expect(event.uuid).to be_nil
          event.save!
          expect(event.uuid).not_to be_nil
        end
      end

      context "existent event" do
        before(:each) do
          event.save!
        end

        it "does not saves new uuid" do
          old_uuid = event.uuid
          event.save!
          expect(event.reload.uuid).to eq(old_uuid)
        end
      end
    end
  end

  describe "#status" do
    %w(draft published canceled).each do |status|

      before do
        event.status = nil
      end

      it { is_expected.to respond_to "#{status}?" }
      it "should be #{status}" do
        expect do
          event.status = status
        end.to change { event.send("#{status}?") }.from(false).to(true)
      end
    end
  end

  describe "#formatted_status" do
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:event) { create(:event, course: course) }

    context "it's draft and" do
      before do
        event.status = "draft"
        event.topics = []
      end

      it "there's no topics" do
        expect(event.formatted_status(teacher)).to eq("empty")
      end

      context "there's at least one topic" do
        before do
          event.topics << build(:topic)
        end

        context "as teacher" do
          it { expect(event.reload.formatted_status(teacher)).to eq("draft") }
        end

        context "as student" do
          it { expect(event.reload.formatted_status(student)).to eq("empty") }
        end
      end
    end

    context "it's published and" do
      before do
        event.status = "published"
        event.topics = []
      end

      it "there's no topics" do
        Timecop.freeze(event.end_at - 1.hour) do
          expect(event.formatted_status(teacher)).to eq("published")
        end
      end

      it "it already happened" do
        Timecop.freeze(event.end_at + 1.hour) do
          expect(event.formatted_status(teacher)).to eq("happened")
        end
      end
    end

    context "it's canceled" do
      before do
        event.status = "canceled"
      end

      it { expect(event.formatted_status(teacher)).to eq("canceled") }
    end
  end

  describe "#order" do
    let(:previous_event) do
      build(
        :event,
        course: event.course,
        start_at: event.start_at - 1.day
      )
    end

    let(:next_event) do
      build(
        :event,
        course: event.course,
        start_at: event.start_at + 1.day
      )
    end

    before do
      event.save!
      previous_event.save!
      next_event.save!
    end

    it { expect(previous_event.order).to eq(1) }
    it { expect(event.order).to eq(2) }
    it { expect(next_event.order).to eq(3) }

    describe "#previous" do
      it { expect(event.previous).to eq(previous_event) }

      context "it's the first event" do
        before do
          previous_event.destroy
        end

        it { expect(event.previous).to be_nil }
      end
    end

    describe "#next" do
      it { expect(event.next).to eq(next_event) }

      context "it's the last event" do
        before do
          next_event.destroy
        end

        it { expect(event.next).to be_nil }
      end
    end
  end
end
