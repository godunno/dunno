class RenameTopicTextToDescription < ActiveRecord::Migration
  def change
    rename_column :topics, :text, :description
  end
end
