class AddMediaToTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :media, index: true
  end
end
