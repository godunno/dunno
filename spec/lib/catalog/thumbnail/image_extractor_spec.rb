require_relative '../../../../lib/catalog/thumbnail/image_extractor'

describe Catalog::ImageExtractor do
  it "should return the URL if it's an image" do
    name = "image.png"
    path = "path/to/#{name}"
    expect(Catalog::ImageExtractor.new(double(name: name, path: path)).extract).to eq(path)
  end

  it "should return nil if it's not an image" do
    name = "document.doc"
    path = "path/to/#{name}"
    expect(Catalog::ImageExtractor.new(double(name: name, path: path)).extract).to be_nil
  end
end
