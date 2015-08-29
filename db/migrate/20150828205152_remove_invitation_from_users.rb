class RemoveInvitationFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :invitation_token
    remove_column :users, :invitation_token, :string
    remove_column :users, :invitation_sent_at, :datetime
  end
end
