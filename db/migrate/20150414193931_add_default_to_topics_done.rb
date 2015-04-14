class AddDefaultToTopicsDone < ActiveRecord::Migration
  def change
    change_column_default :topics, :done, false
  end
end
