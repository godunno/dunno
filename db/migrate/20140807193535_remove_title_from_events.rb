class RemoveTitleFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :title, :string
  end
end
