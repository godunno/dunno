class MigrateStudentsToProfiles < ActiveRecord::Migration
  def change
    Student.find_each do |student|
      profile = Profile.create!

      student.user.update!(profile: profile)

      student.courses.find_each do |course|
        course.add_student(profile)
      end

      student.destroy!
    end
  end
end
