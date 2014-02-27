class SetDefaultOnStatusFromEvents < ActiveRecord::Migration
  def up
    change_column :events, :status, :string, default: 'available'
  end

  def down
    change_column :events, :status, :string, default: nil
  end
end
