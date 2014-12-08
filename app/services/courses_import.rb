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
        course = teacher.courses.find_by(name: row[0], class_name: row[1]) || Course.new
        course.update!(
          teacher: teacher,
          name: row[0],
          class_name: row[1],
          start_date: row[2],
          end_date: row[3]
        )
        row[6..12].each_with_index.map do |value, index|
          next unless value == 'x'
          WeeklySchedule.create!(
            start_time: row[4],
            end_time: row[5],
            weekday: index,
            classroom: row[13],
            course: course
          )
        end
        courses << course
      end
      courses.each { |course| CourseScheduler.new(course.reload).schedule! }
    end
  end
end
