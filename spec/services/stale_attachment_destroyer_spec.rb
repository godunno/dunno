require 'spec_helper'

describe StaleAttachmentDestroyer do
  let!(:attachment_with_comment) do
    create(:attachment, comment_id: 1, created_at: 2.months.ago)
  end
  let!(:recent_attachment) { create(:attachment, created_at: 1.week.ago) }
  let!(:stale_attachment) { create(:attachment, created_at: 1.month.ago - 1.day) }

  before { StaleAttachmentDestroyer.new.run }

  it "only removes attachments with no comment attached to it" do
    expect(Attachment.all).to eq [attachment_with_comment, recent_attachment]
  end
end
