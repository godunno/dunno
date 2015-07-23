class CoursesImport
  attr_reader :teacher, :url

  def self.import!(*args)
    new(*args).import!
  end

  def initialize(teacher, url)
    @teacher = teacher
    @url = url
  end

  # Each row contain the columns:
  # 0 => name
  # 1 => class name
  # 2 => start date
  # 3 => end date
  # 4 => start time
  # 5 => end time
  # 6..12 => weekdays
  # 13 => classroom
  def import!
    ActiveRecord::Base.transaction do
      courses = Set.new
      SpreadsheetParser.parse(url, header_rows: 2).each do |row|
        class_name = fix_possible_float(row[1])
        course = teacher.courses.find_or_initialize_by(name: row[0], class_name: class_name)
        course.update!(
          teacher: teacher,
          start_date: row[2],
          end_date: row[3]
        )
        row[6..12].each_with_index.map do |value, index|
          next unless value == 'x'
          course.weekly_schedules.create!(
            start_time: format_time(row[4]),
            end_time: format_time(row[5]),
            weekday: index,
            classroom: fix_possible_float(row[13]),
          )
        end
        courses << course
      end
    end
  end

  private

  def format_time(time)
    time.rjust(5, '0')
  end

  def fix_possible_float(value)
    value.is_a?(Float) ? value.truncate.to_s : value
  end
end
