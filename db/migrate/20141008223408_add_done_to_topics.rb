class AddDoneToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :done, :boolean
  end
end
