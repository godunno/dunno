module CoursesHelper
  def weekdays
    Course::WEEKDAYS.map do |day|
      [I18n.t('date.abbr_day_names')[day], day]
    end
  end
end
