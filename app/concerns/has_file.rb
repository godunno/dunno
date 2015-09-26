module HasFile
  extend ActiveSupport::Concern

  included do
    after_commit :delete_file, on: [:destroy], if: :file?

    def file
      AwsFile.new(file_url) if file?
    end

    def thumbnail
      file? && super.present? && !(super =~ %r{/assets/thumbnails/}) ? AwsFile.new(super).url : super
    end

    def file?
      file_url.present?
    end
  end

  private

  def delete_file
    DeleteAwsFileWorker.perform_async(file_url)
  end
end
