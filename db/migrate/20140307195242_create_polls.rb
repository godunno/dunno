class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :content
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
