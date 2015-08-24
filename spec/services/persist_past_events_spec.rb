require 'spec_helper'

describe PersistPastEvents do
  let(:first_date) { Time.zone.parse('2015-08-01 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-02 23:59') }
  let(:third_date) { Time.zone.parse('2015-08-03 23:59') }
  let(:today) { third_date }

  let(:course) { create(:course, start_date: first_date - 1.day, end_date: first_date + 1.month) }
  let!(:event) { create(:event, course: course, start_at: first_date) }
  let!(:yesterday_schedule) { create(:weekly_schedule, course: course, weekday: 6, start_time: "09:00") }
  let!(:today_schedule) { create(:weekly_schedule, course: course, weekday: 0, start_time: "23:59") }
  let!(:tomorrow_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: "23:59") }

  before { Timecop.travel today }
  after { Timecop.return }

  context "saving since the beginning of the course" do
    it do
      expect(course.reload.events.map(&:start_at)).to eq [event.start_at]
      PersistPastEvents.new(course, since: course.start_date).persist!
      expect(course.reload.events.map(&:start_at)).to eq [
        first_date,
        second_date,
        third_date
      ]
    end
  end

  context "saving only since today" do
    it do
      expect(course.reload.events.map(&:start_at)).to eq [event.start_at]
      PersistPastEvents.new(course).persist!
      expect(course.reload.events.map(&:start_at)).to eq [
        first_date,
        third_date
      ]
    end
  end
end
