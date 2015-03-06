module HasFile
  # TODO: Tests
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_file
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
    file.try(:delete)
  end
end
