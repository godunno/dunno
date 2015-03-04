require './lib/catalog/media_thumbnail_wrapper'
require './app/services/aws_file'

describe Catalog::MediaThumbnailWrapper do
  context "with url" do
    let(:url) { "http://www.example.com/image.png" }
    subject { Catalog::MediaThumbnailWrapper.new(double(url: url, file_url: nil)) }
    it { expect(subject.name).to eq(url) }
    it { expect(subject.path).to eq(url) }
  end

  context "with file" do
    let(:name) { "image.png" }
    let(:path) { "path/to/image.png" }
    before do
      allow_any_instance_of(AwsFile).to receive(:url).and_return(path)
    end
    subject { Catalog::MediaThumbnailWrapper.new(double(url: nil, file_url: path, original_filename: name)) }
    it { expect(subject.name).to eq(name) }
    it { expect(subject.path).to eq(path) }
  end
end
