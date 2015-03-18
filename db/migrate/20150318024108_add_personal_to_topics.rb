class AddPersonalToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :personal, :boolean, default: false
  end
end
