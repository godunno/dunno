class AddCompletedTutorialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :completed_tutorial, :boolean, default: false
  end
end
