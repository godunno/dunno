class SetMediaTeachers < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Media.find_each do |media|
        if media.mediable.present?
          media.update!(teacher: media.mediable.event.course.teacher)
        end
      end
    end
  end
end
