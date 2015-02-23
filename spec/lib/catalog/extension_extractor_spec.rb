require './lib/catalog/extension_extractor'

describe Catalog::ExtensionExtractor do

  shared_examples "extracting thumbnail doc file" do
    subject { Catalog::ExtensionExtractor.new(target).extract }
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

  context "returning nil when unable to extract extension due to" do
    def extraction_should_default(name)
      target = double(name: name)
      expect(Catalog::ExtensionExtractor.new(target).extract).to be_nil
    end

    it "unsupported extension" do
      extraction_should_default("unsupported.xyz")
    end

    it "name without extension" do
      extraction_should_default("without_extension")
    end
  end

  it "should have a constructor method" do
    extractor = spy('ExtensionExtractor')
    name = 'file.doc'
    object = double(name: name, path: name)
    allow(Catalog::ExtensionExtractor).to receive(:new).with(object).and_return(extractor)
    Catalog::ExtensionExtractor.extract(object)
    expect(extractor).to have_received(:extract)
  end
end
