class AddOpenedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :opened_at, :datetime
  end
end
