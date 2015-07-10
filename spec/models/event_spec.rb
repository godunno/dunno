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

  describe ".search_by_course", :elasticsearch do
    let!(:course) { create(:course) }
    let!(:past_event) { create(:event, course: course, start_at: 1.week.ago, status: 'draft') }
    let!(:today_event) { create(:event, course: course, start_at: Time.current, status: 'canceled') }
    let!(:future_event) { create(:event, course: course, start_at: 1.day.from_now, status: 'published') }
    let!(:unpublished_future_event) { create(:event, course: course, start_at: 1.day.from_now, status: 'draft') }
    let!(:event_from_another_course) { create(:event) }

    before { refresh_index! }

    it "can set a number of items per page" do
      expect(Event.search_by_course(course, per_page: 1).records.to_a).to eq([future_event])
    end

    it "paginates" do
      expect(Event.search_by_course(course, per_page: 1, page: 2).records.to_a).to eq([today_event])
    end

    it "shows a page starting at the newer published event, ordered from newest to oldest" do
      expect(Event.search_by_course(course, {}).records.to_a).to eq([future_event, today_event, past_event])
    end

    it "returns everything until datetime" do
      expect(Event.search_by_course(course, until: today_event.start_at).records.to_a).to eq([future_event, today_event])
    end

    it "sets an offset with pagination" do
      expect(Event.search_by_course(course, offset: 1, per_page: 1, page: 2).records.to_a).to eq([past_event])
    end

    it "ignores pagination when there's an :until parameter" do
      expect(Event.search_by_course(course, offset: 1, per_page: 1, page: 2, until: today_event.start_at).records.to_a).to eq([future_event, today_event])
    end

    it "ignores :until parameter if it's later than the newest published event" do
      expect(Event.search_by_course(course, until: unpublished_future_event.start_at).records.to_a).to eq([future_event, today_event, past_event])
    end

    it "loads loads all the events until the specified, no matter how many" do
      another_course = create(:course)
      events = (1..11).map { |i| create(:event, course: another_course, start_at: i.days.ago) }
      refresh_index!
      expect(Event.search_by_course(another_course, until: events.last.start_at).records.to_a).to eq(events)
    end
  end
end
