class GenerateAbbreviationsForCourses < ActiveRecord::Migration
  def change
    Course.find_each do |course|
      course.update!(abbreviation: Abbreviate.abbreviate(course.name))
    end
  end
end
