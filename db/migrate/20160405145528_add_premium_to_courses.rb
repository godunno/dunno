class AddPremiumToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :premium, :boolean, default: false
  end
end
