require 'spec_helper'

describe WeeklyRule do
  describe "#rule_for_event_listing" do
    let(:weekly_schedule) do
      create :weekly_schedule,
              start_time: '09:00',
              end_time: '11:00'
    end
    let(:weekly_rule) { WeeklyRule.new(weekly_schedule) }
    subject { weekly_rule.rule_for_event_listing.to_s }

    it "creates a rule without an end" do
      weekly_schedule.course.update!(end_date: nil)
      is_expected.to eq(
        'Weekly on Mondays on the 9th hour of the day on ' +
        'the 0th minute of the hour on the 0th ' +
        'second of the minute'
      )
    end

    it "creates a rule with the course's end date" do
      weekly_schedule.course.update!(
        start_date: Date.parse('2015-07-30'),
        end_date: Date.parse('2015-07-31')
      )
      is_expected.to eq(
        'Weekly on Mondays on the 9th hour of the day ' +
        'on the 0th minute of the hour on the 0th second ' +
        'of the minute until July 31, 2015'
      )
    end
  end

  describe "#rule_for_weekly_schedule_transfer" do
    let(:weekly_schedule) do
      create :weekly_schedule,
             start_time: '09:00',
             end_time: '11:00',
             course: course
    end
    let(:weekly_rule) { WeeklyRule.new(weekly_schedule) }
    subject { weekly_rule.rule_for_weekly_schedule_transfer.to_s }

    context "with course's end date" do
      let!(:course) do
        create(:course, start_date: Date.parse('2015-07-30'), end_date: Date.parse('2015-07-31'))
      end

      it "uses the course's end date for its limit" do
        is_expected.to eq(
          'Weekly on Mondays on the 9th hour of the day ' +
          'on the 0th minute of the hour on the 0th second ' +
          'of the minute until July 31, 2015'
        )
      end
    end

    context "without course's end date" do
      let!(:course) { create(:course, end_date: nil) }

      context "with event" do
        let!(:event) do
          create :event,
                 course: course,
                 start_at: Time.zone.parse('2015-07-31 09:00')
        end

        it "creates a rule with until_time 1 week after the last event's start_at" do
          is_expected.to eq(
            'Weekly on Mondays on the 9th hour of the day on the ' +
            '0th minute of the hour on the 0th second ' +
            'of the minute until August  7, 2015'
          )
        end
      end

      context "without event" do
        before do
          Timecop.freeze Time.zone.parse('2015-08-07 2:00')
        end
        after { Timecop.return }

        it "sets the until_time for today" do
          is_expected.to eq(
            'Weekly on Mondays on the 9th hour of the day on the ' +
            '0th minute of the hour on the 0th second ' +
            'of the minute until August  7, 2015'
          )
        end
      end
    end
  end
end
