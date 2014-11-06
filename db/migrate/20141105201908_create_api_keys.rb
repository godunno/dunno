class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :token
      t.belongs_to :user, index: true

      t.timestamps
    end

    add_index :api_keys, :token, unique: true
  end
end
