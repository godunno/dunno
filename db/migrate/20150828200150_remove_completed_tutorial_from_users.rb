class RemoveCompletedTutorialFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :completed_tutorial, :boolean
  end
end
