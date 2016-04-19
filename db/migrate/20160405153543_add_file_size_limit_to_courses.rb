class AddFileSizeLimitToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :file_size_limit, :integer, default: 10.megabytes
  end
end
