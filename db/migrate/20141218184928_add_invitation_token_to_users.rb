class AddInvitationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_token, :string
    add_index :users, :invitation_token, unique: true
  end
end
