require 'spec_helper'

describe WeeklySchedule do
  describe "associations" do
    it { should belong_to(:course) }
  end

  describe "validations" do
    %w(weekday start_time end_time).each do |attr|
      it { should validate_presence_of(attr) }
    end
  end
end
