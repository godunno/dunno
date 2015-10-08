class AddCommentToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :comment, index: true
  end
end
