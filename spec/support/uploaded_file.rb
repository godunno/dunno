# -*- encoding : utf-8 -*-
module UploadFileTestHelper
  def uploaded_file(filename, content_type = "text/csv")
    t = Tempfile.new([filename.split("/").last, filename.split(".").last])
    t.binmode
    path = File.join(Rails.root, "spec", "fixtures", filename)
    FileUtils.copy_file(t.path, path)
    Rack::Test::UploadedFile.new(path, content_type)
  end
end

RSpec.configure do |config|
  config.include UploadFileTestHelper
end
