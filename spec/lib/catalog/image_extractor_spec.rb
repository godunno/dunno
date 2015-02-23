require './lib/catalog/image_extractor'

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

  it "should have a constructor method" do
    extractor = spy('ImageExtractor')
    name = 'image.png'
    object = double(path: name, name: name)
    allow(Catalog::ImageExtractor).to receive(:new).with(object).and_return(extractor)
    Catalog::ImageExtractor.extract(object)
    expect(extractor).to have_received(:extract)
  end
end
