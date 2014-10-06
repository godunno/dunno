class ChangeStatusToIntegerOnEvents < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      remove_column :events, :status, :string, default: "available"
      add_column :events, :status, :integer, default: 0
    end
  end
end
