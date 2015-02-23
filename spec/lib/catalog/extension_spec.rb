require './lib/catalog/extension'

describe Catalog::Extension do
  %w(file.doc /path/to/file.doc http://www.example.com/file.doc http://www.example.com/file.doc?auth_token=nA33sfkjw3sxz).each do |file|
    it { expect(Catalog::Extension.new(file).name).to eq("doc") }
  end

  it "should have a constructor method" do
    extension = spy('ExtensionThumbnailExtractor')
    name = 'file.doc'
    allow(Catalog::Extension).to receive(:new).with(name).and_return(extension)
    Catalog::Extension.from(name)
    expect(extension).to have_received(:name)
  end
end
