class AddOrderToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :order, :integer
  end
end
