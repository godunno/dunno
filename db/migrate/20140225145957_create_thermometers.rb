class CreateThermometers < ActiveRecord::Migration
  def change
    create_table :thermometers do |t|
      t.belongs_to :event, index: true
      t.string :content

      t.timestamps
    end
  end
end
