require 'spec_helper'

RSpec.describe Attachment, type: :model do
  let(:attachment) { build(:attachment) }

  describe "associations" do
    it { is_expected.to belong_to :profile }
    it { is_expected.to belong_to :comment }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:original_filename) }
    it { is_expected.to validate_presence_of(:file_url) }
    it { is_expected.to validate_presence_of(:file_size) }
    it { is_expected.to validate_presence_of(:profile) }
  end

  it "uses AwsFile to mount the url" do
    expect(attachment.file).to be_a(AwsFile)
  end

  it "generates an authenticated S3 URL to the file" do
    expect(attachment.file.url).to include attachment.file_url
  end

  it "deletes the file along with itself" do
    expect(DeleteAwsFileWorker).to receive(:perform_async).with(attachment.file_url)
    attachment.destroy
    attachment.run_callbacks(:commit)
  end

  it "delegates #url to file" do
    is_expected.to delegate_method(:url).to(:file)
  end
end
