class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_at
      t.string :status
      t.belongs_to :organization

      t.timestamps
    end
  end
end
