class StaleAttachmentDestroyer
  def run
    Attachment.where(comment_id: nil).where('created_at < ?', 1.month.ago).destroy_all
  end
end
