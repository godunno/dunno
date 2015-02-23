require 'spec_helper'

describe Catalog::ThumbnailExtractor do
  def media_double(url: nil, file: nil, preview: nil)
    media = double("media", url: url, file: file)
    allow(media).to receive_message_chain(:preview, :images, :first, :src, to_s: preview)
    media
  end

  context "from preview" do
    it "should be able to extract thumbnail from the media preview" do
      preview = "http://www.example.com/image.png"
      media = media_double(url: "http://www.example.com", preview: preview)
      expect(Catalog::ThumbnailExtractor.new(media).extract).to eq(preview)
    end
  end

  #context "from image file" do
  #  let(:file) { double("file", path: "/path/to/image.png", original_filename: "image.png") }
  #  let(:media) { media_double(file: file) }
  #  it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq(file.path) }
  #end

  context "from file extension" do
    let(:file) { double("file", path: "/path/to/document.doc", original_filename: "document.doc") }
    let(:media) { media_double(file: file) }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/doc.png") }
  end

  context "URL default" do
    let(:media) { media_double(url: "http://www.example.com") }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/url.png") }
  end

  context "file default" do
    let(:file) { double("file", path: "/path/to/invalid_extension.xyz", original_filename: "invalid_extension.xyz") }
    let(:media) { media_double(file: file) }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/file.png") }
  end
end
