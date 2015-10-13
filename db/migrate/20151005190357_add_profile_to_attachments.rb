class AddProfileToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :profile, index: true
  end
end
