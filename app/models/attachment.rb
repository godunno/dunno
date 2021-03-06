class Attachment < ActiveRecord::Base
  after_commit :delete_file, on: [:destroy]

  belongs_to :profile
  belongs_to :comment

  validates :profile, :original_filename, :file_url, :file_size, presence: true

  delegate :url, to: :file

  def file
    AwsFile.new(file_url)
  end

  private

  def delete_file
    DeleteAwsFileWorker.perform_async(file_url)
  end
end
