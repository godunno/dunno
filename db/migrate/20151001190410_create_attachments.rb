class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :original_filename, null: false
      t.string :file_url, null: false
      t.integer :file_size, null: false

      t.timestamps
    end
  end
end
