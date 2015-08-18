require 'spec_helper'

describe SearchEventsByCourse, :elasticsearch do
  let(:first_date) { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date) { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date) { Time.zone.parse('2015-08-31 09:00') }
  let!(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00') }
  let!(:course) { create(:course, weekly_schedules: [weekly_schedule], start_date: Date.parse('2015-08-01'), end_date: Date.parse('2015-08-31')) }

  describe "#finished?" do
    subject { SearchEventsByCourse.new(course, options) }

    before do
      Timecop.travel fifth_date
      refresh_index!
    end

    after { Timecop.return }

    context "first page" do
      let(:options) { { per_page: 1, page: 1 } }

      it { is_expected.not_to be_finished }
    end

    context "second page after offset" do
      let(:options) { { offset: 1, per_page: 1, page: 2 } }

      it { is_expected.not_to be_finished }
    end

    context "last page" do
      let(:options) { { per_page: 1, page: 5 } }

      it { is_expected.to be_finished }
    end

    context "last page" do
      let(:options) { { per_page: 1, page: 5 } }

      it { is_expected.to be_finished }
    end

    context "last page after offset" do
      let(:options) { { offset: 1, per_page: 1, page: 4 } }

      it { is_expected.to be_finished }
    end
  end

  describe "#search" do
    let!(:past_event) { create(:event, course: course, start_at: first_date, status: 'draft') }
    let!(:today_event) { create(:event, course: course, start_at: second_date, status: 'canceled') }
    let!(:future_event) { create(:event, course: course, start_at: fourth_date, status: 'published') }
    let!(:unpublished_future_event) { create(:event, course: course, start_at: fifth_date, status: 'draft') }
    let!(:event_from_another_course) { create(:event) }

    before do
      Timecop.freeze second_date
      refresh_index!
    end

    after { Timecop.return }

    subject do
      SearchEventsByCourse.new(course, options).search
      .map(&:start_at)
    end

    describe "sets a number of items per page" do
      let(:options) { { per_page: 1 } }
      it { expect(subject).to eq([fourth_date]) }
    end

    describe "pagination" do
      let(:options) { { per_page: 1, page: 2 } }
      it { expect(subject).to eq([third_date]) }
    end

    describe "shows a page starting at the newer published event, ordered from newest to oldest" do
      let(:options) { {} }
      it { expect(subject).to eq([fourth_date, third_date, second_date, first_date]) }
    end

    describe "returns everything until datetime" do
      let(:options) { { until: today_event.start_at } }
      it { expect(subject).to eq([fourth_date, third_date, second_date]) }
    end

    describe "sets an offset with pagination" do
      let(:options) { { offset: 1, per_page: 1, page: 2 } }
      it { expect(subject).to eq([second_date]) }
    end

    describe "ignores pagination when there's an :until parameter" do
      let(:options) { { offset: 1, per_page: 1, page: 2, until: today_event.start_at } }
      it { expect(subject).to eq([fourth_date, third_date, second_date]) }
    end

    describe "ignores :until parameter if it's later than the newest published event" do
      let(:options) { { until: unpublished_future_event.start_at } }
      it { expect(subject).to eq([fourth_date, third_date, second_date, first_date]) }
    end

    it "loads all the events until the specified, no matter how many" do
      another_course = create(:course, start_date: 11.days.ago)
      events = (1..11).map { |i| create(:event, course: another_course, start_at: i.days.ago) }
      refresh_index!
      expect(SearchEventsByCourse.search(another_course, until: events.last.start_at)).to eq(events)
    end

    it "starts from today if there's no published event" do
      [past_event, today_event, future_event].each { |event| event.update!(status: 'draft') }
      expect(SearchEventsByCourse.search(course, {})).to eq([today_event, past_event])
    end
  end
end
