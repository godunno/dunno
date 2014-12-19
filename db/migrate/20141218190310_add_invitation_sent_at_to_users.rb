class AddInvitationSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_sent_at, :datetime
  end
end
