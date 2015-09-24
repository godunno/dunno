class AddFacebookInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :avatar_url, :string

    add_index :users, :facebook_uid
  end
end
