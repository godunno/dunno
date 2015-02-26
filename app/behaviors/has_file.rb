module HasFile
  extend ActiveSupport::Concern
  
  included do
    before_destroy :delete_file
    define_method(:file) do
      AwsFile.new(self[:file]) if self[:file].present?
    end
  end

  private

  def delete_file
    file.try(:delete!)
  end
end
