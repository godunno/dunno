require_relative '../../../../lib/catalog/thumbnail/extension_thumbnail_extractor'

describe Catalog::ExtensionThumbnailExtractor do

  shared_examples "extracting thumbnail doc file" do
    subject { Catalog::ExtensionThumbnailExtractor.new(target).extract }
    it { expect(subject).to eq("doc") }
  end

  describe "from filename" do
    let(:target) { double(name: "file.doc") }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from file path" do
    let(:target) { double(name: "/path/to/file/file.doc") }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from URL" do
    let(:target) { double(name: "http://www.example.com/file.doc") }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from URL with parameters" do
    let(:target) { double(name: "http://www.example.com/file.doc?auth_token=nA33sfkjw3sxz") }
    it_behaves_like "extracting thumbnail doc file"
  end

  context "defaulting when trying to extract" do
    def extraction_should_default(name)
      target = double(name: name)
      expect(Catalog::ExtensionThumbnailExtractor.new(target).extract).to be_nil
    end

    it "unsupported extension" do
      extraction_should_default("unsupported.xyz")
    end

    it "from name without extension" do
      extraction_should_default("without_extension")
    end
  end

  it "should have a constructor method" do
    extractor = spy('ExtensionThumbnailExtractor')
    name = 'file.doc'
    allow(Catalog::ExtensionThumbnailExtractor).to receive(:new).with(name).and_return(extractor)
    Catalog::ExtensionThumbnailExtractor.extract(name)
    expect(extractor).to have_received(:extract)
  end
end
