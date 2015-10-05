FactoryGirl.define do
  factory :attachment do
    profile
    original_filename "file.txt"
    file_url "path/to/file.txt"
    file_size 12345
  end

end
