class AddAbbreviationToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :abbreviation, :string, limit: 10
  end
end
