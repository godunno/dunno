module HasFile
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_file
    define_method(:file) do
      AwsFile.new(file_url) if file_url.present?
    end
  end

  private

  def delete_file
    file.try(:delete)
  end
end
