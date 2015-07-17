require 'spec_helper'

describe SearchEventsByCourse, :elasticsearch do
  describe ".search" do
    let!(:course) { create(:course) }
    let!(:past_event) { create(:event, course: course, start_at: 1.week.ago, status: 'draft') }
    let!(:today_event) { create(:event, course: course, start_at: Time.current, status: 'canceled') }
    let!(:future_event) { create(:event, course: course, start_at: 1.day.from_now, status: 'published') }
    let!(:unpublished_future_event) { create(:event, course: course, start_at: 1.day.from_now, status: 'draft') }
    let!(:event_from_another_course) { create(:event) }

    before { refresh_index! }

    it "can set a number of items per page" do
      expect(SearchEventsByCourse.search(course, per_page: 1).records.to_a).to eq([future_event])
    end

    it "paginates" do
      expect(SearchEventsByCourse.search(course, per_page: 1, page: 2).records.to_a).to eq([today_event])
    end

    it "shows a page starting at the newer published event, ordered from newest to oldest" do
      expect(SearchEventsByCourse.search(course, {}).records.to_a).to eq([future_event, today_event, past_event])
    end

    it "returns everything until datetime" do
      expect(SearchEventsByCourse.search(course, until: today_event.start_at).records.to_a).to eq([future_event, today_event])
    end

    it "sets an offset with pagination" do
      expect(SearchEventsByCourse.search(course, offset: 1, per_page: 1, page: 2).records.to_a).to eq([past_event])
    end

    it "ignores pagination when there's an :until parameter" do
      expect(SearchEventsByCourse.search(course, offset: 1, per_page: 1, page: 2, until: today_event.start_at).records.to_a).to eq([future_event, today_event])
    end

    it "ignores :until parameter if it's later than the newest published event" do
      expect(SearchEventsByCourse.search(course, until: unpublished_future_event.start_at).records.to_a).to eq([future_event, today_event, past_event])
    end

    it "loads loads all the events until the specified, no matter how many" do
      another_course = create(:course)
      events = (1..11).map { |i| create(:event, course: another_course, start_at: i.days.ago) }
      refresh_index!
      expect(SearchEventsByCourse.search(another_course, until: events.last.start_at).records.to_a).to eq(events)
    end

    it "starts from today if there's no published event" do
      [past_event, today_event, future_event].each { |event| event.update!(status: 'draft') }
      expect(SearchEventsByCourse.search(course, {}).records.to_a).to eq([today_event, past_event])
    end
  end
end
