class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :profile, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
