require './lib/catalog/extension'

describe Catalog::Extension do

  it { expect(Catalog::Extension.new("file.doc").name).to eq("doc") }
  it { expect(Catalog::Extension.new("file.DOC").name).to eq("doc") }
  it { expect(Catalog::Extension.new("/path/to/file.doc").name).to eq("doc") }
  it { expect(Catalog::Extension.new("http://www.example.com/file.doc").name).to eq("doc") }
  it { expect(Catalog::Extension.new("http://www.example.com/file.doc?auth_token=nA33sfkjw3sxz)").name).to eq("doc") }
  it { expect(Catalog::Extension.new("http://www.example.com/file.doc?next=a.pdf").name).to eq("doc") }

  it { expect(Catalog::Extension.new("image.png")).to be_image }
  it { expect(Catalog::Extension.new("Cowboy Bebop CD Box Set.jpg")).to be_image }

  it { expect(Catalog::Extension.new("unsupported.xyz")).not_to be_supported }

  it "should have a constructor method" do
    extension = spy('ExtensionThumbnailExtractor')
    name = 'file.doc'
    expect(Catalog::Extension).to receive(:new).with(name).and_return(extension)
    Catalog::Extension.from(name)
  end
end
