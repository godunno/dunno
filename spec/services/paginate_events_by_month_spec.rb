require 'spec_helper'

describe PaginateEventsByMonth do
  before do
    Timecop.freeze Time.zone.parse("2014-12-31 23:30")
  end

  after { Timecop.return }

  context "without given month" do
    let(:pagination) { PaginateEventsByMonth.new(Event.all, nil) }

    context "with events in current month" do
      let!(:event_from_december) { create(:event, start_at: "2014-12-01 01:00:00") }
      let!(:event_from_january) { create(:event, start_at: "2015-01-01 01:00:00") }

      it { expect(pagination.events).to eq([event_from_december]) }
      it { expect(pagination.current_month).to eq("2014-12-01 00:00:00".in_time_zone) }
      it { expect(pagination.next_month).to eq("2015-01-01 00:00:00".in_time_zone) }
      it { expect(pagination.previous_month).to eq("2014-11-01 00:00:00".in_time_zone) }
    end

    context "with no events in current month" do
      context "with events in the future" do
        let!(:event_from_january) { create(:event, start_at: "2015-01-01 01:00:00") }

        it { expect(pagination.events).to eq([event_from_january]) }
        it { expect(pagination.current_month).to eq("2015-01-01 00:00:00".in_time_zone) }
        it { expect(pagination.next_month).to eq("2015-02-01 00:00:00".in_time_zone) }
        it { expect(pagination.previous_month).to eq("2014-12-01 00:00:00".in_time_zone) }
      end

      context "with no events in the future, but events in the past" do
        let!(:event_from_january) { create(:event, start_at: "2014-01-01 01:00:00") }
        let!(:event_from_november) { create(:event, start_at: "2014-11-01 01:00:00") }

        it { expect(pagination.events).to eq([event_from_november]) }
        it { expect(pagination.current_month).to eq("2014-11-01 00:00:00".in_time_zone) }
        it { expect(pagination.next_month).to eq("2014-12-01 00:00:00".in_time_zone) }
        it { expect(pagination.previous_month).to eq("2014-10-01 00:00:00".in_time_zone) }
      end

      context "with no events at all" do
        it { expect(pagination.events).to be_blank }
        it { expect(pagination.current_month).to eq("2014-12-01 00:00:00".in_time_zone) }
        it { expect(pagination.next_month).to eq("2015-01-01 00:00:00".in_time_zone) }
        it { expect(pagination.previous_month).to eq("2014-11-01 00:00:00".in_time_zone) }
      end
    end
  end

  context "with given month" do
    let!(:event_from_july) { create(:event, start_at: "2015-07-01 01:00:00") }
    let!(:event_from_august) { create(:event, start_at: "2015-08-01 01:00:00") }
    let(:pagination) { PaginateEventsByMonth.new(Event.all, "2015-07-15T17:00:00Z") }

    it { expect(pagination.events).to eq([event_from_july]) }
    it { expect(pagination.current_month).to eq("2015-07-01 00:00:00".in_time_zone) }
    it { expect(pagination.next_month).to eq("2015-08-01 00:00:00".in_time_zone) }
    it { expect(pagination.previous_month).to eq("2015-06-01 00:00:00".in_time_zone) }
  end
end
