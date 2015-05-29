class MigrateTeachersToProfiles < ActiveRecord::Migration
  def change
    Teacher.find_each do |teacher|
      profile = Profile.create!

      teacher.user.update!(profile: profile)

      teacher.medias.find_each do |media|
        media.update!(profile: profile)
      end

      teacher.courses.find_each do |course|
        course.update!(teacher: profile)
      end

      teacher.destroy!
    end
  end
end
