class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :content
      t.belongs_to :poll, index: true

      t.timestamps
    end
  end
end
