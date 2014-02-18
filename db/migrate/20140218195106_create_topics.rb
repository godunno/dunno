class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :text
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
