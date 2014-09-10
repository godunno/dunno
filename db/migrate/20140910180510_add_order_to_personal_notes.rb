class AddOrderToPersonalNotes < ActiveRecord::Migration
  def change
    add_column :personal_notes, :order, :integer
  end
end
