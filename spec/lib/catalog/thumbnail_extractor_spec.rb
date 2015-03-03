require 'spec_helper'

describe Catalog::ThumbnailExtractor do
  def media_double(url: nil, file: nil, original_filename: nil, preview: nil)
    media = double("media", url: url, file: file, original_filename: original_filename)
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
  #  let(:original_filename) { "image.png" }
  #  let(:file) { "path/to/image.png" }
  #  let(:media) { media_double(file: file, original_filename: original_filename) }
  #  it { expect(Catalog::ThumbnailExtractor.new(media).extract).to match(/#{file}/) }
  #end

  context "from file extension" do
    let(:original_filename) { "document.doc" }
    let(:file) { "path/to/document.doc" }
    let(:media) { media_double(file: file, original_filename: original_filename) }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/doc.png") }
  end

  context "URL default" do
    let(:media) { media_double(url: "http://www.example.com") }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/url.png") }
  end

  context "file default" do
    let(:original_filename) { "invalid_extension.xyz" }
    let(:file) { "path/to/invalid_extension.xyz" }
    let(:media) { media_double(file: file, original_filename: original_filename) }
    it { expect(Catalog::ThumbnailExtractor.new(media).extract).to eq("/assets/thumbnails/file.png") }
  end
end
