require 'spec_helper'

describe MonthsNavigation do
  let(:service) { MonthsNavigation.new(day_in_month) }

  context "without specifying day in month" do
    let(:day_in_month) { nil }

    it { expect(service.previous_month).to eq 1.month.ago.beginning_of_month }
    it { expect(service.current_month).to eq Time.current.beginning_of_month }
    it { expect(service.next_month).to eq 1.month.from_now.beginning_of_month }
  end

  context "specifying day in month" do
    let(:day_in_month) { 1.month.from_now.utc.iso8601 }

    it { expect(service.previous_month).to eq Time.current.beginning_of_month }
    it { expect(service.current_month).to eq 1.month.from_now.beginning_of_month }
    it { expect(service.next_month).to eq 2.month.from_now.beginning_of_month }
  end
end
