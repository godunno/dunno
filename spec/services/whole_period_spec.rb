require 'spec_helper'

describe WholePeriod do
  let(:service) { WholePeriod.new(day_in_month) }
  let(:day_in_month) { Time.zone.parse('2015-07-15 00:00') }

  it { expect(service.month).to eq day_in_month.beginning_of_month..day_in_month.end_of_month }
  it { expect(service.week).to eq day_in_month.beginning_of_week..day_in_month.end_of_week }
  it { expect(service.day).to eq day_in_month.beginning_of_day..day_in_month.end_of_day }
end
