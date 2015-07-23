require 'spec_helper'

describe WholeMonth do
  let(:service) { WholeMonth.new(day_in_month) }
  let(:day_in_month) { Time.zone.parse('2015-07-15 00:00') }

  it { expect(service.range).to eq day_in_month.beginning_of_month..day_in_month.end_of_month }

end
