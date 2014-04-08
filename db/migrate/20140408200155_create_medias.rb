class CreateMedias < ActiveRecord::Migration
  def change
    create_table :medias do |t|
      t.string :title
      t.string :description
      t.integer :category
      t.string :url
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
