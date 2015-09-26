# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "Português Bolado"
    end_date { Date.tomorrow }
    class_name "101"
    institution "PUC-Rio"
    teacher { build(:profile) }

    trait :with_events do
      start_date { Date.today }

      transient do
        start_time '09:00'
        end_time '11:00'
      end

      weekly_schedules do
        [
          create(:weekly_schedule,
                 weekday: start_date.to_date.wday,
                 start_time: start_time,
                 end_time: end_time)
        ]
      end

      events do
        base_start_at = start_date
                        .to_date
                        .beginning_of_day
                        .change(hour: start_time)
        base_end_at = base_start_at.change(hour: end_time)

        {
          published: 0.weeks,
          canceled: 1.week,
          draft: 2.weeks
        }.map do |status, weeks|
          build(:event, status,
                start_at: base_start_at + weeks,
                end_at: base_end_at + weeks)
        end
      end
    end
  end
end
