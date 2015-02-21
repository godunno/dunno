require_relative '../../../../lib/catalog/thumbnail/media_thumbnail_wrapper'

describe Catalog::MediaThumbnailWrapper do
  context "with url" do
    let(:url) { "http://www.example.com/image.png" }
    subject { Catalog::MediaThumbnailWrapper.new(double(url: url, file: nil)) }
    it { expect(subject.name).to eq(url) }
    it { expect(subject.path).to eq(url) }
  end

  context "with file" do
    let(:name) { "image.png" }
    let(:path) { "path/to/image.png" }
    let(:file) { double(original_filename: name, path: path) }
    subject { Catalog::MediaThumbnailWrapper.new(double(url: nil, file: file)) }
    it { expect(subject.name).to eq(name) }
    it { expect(subject.path).to eq(path) }
  end
end
