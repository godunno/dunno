require 'spec_helper'

describe ExtensionThumbnailExtractor do

  shared_examples "extracting thumbnail doc file" do
    subject { ExtensionThumbnailExtractor.new(target).extract }
    it { expect(subject.extension).to eq("doc") }
    it { expect(subject.path).to eq("/assets/extensions/doc.png") }
  end

  describe "from filename" do
    let(:target) { "file.doc" }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from file path" do
    let(:target) { "/path/to/file/file.doc" }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from URL" do
    let(:target) { "http://www.example.com/file.doc" }
    it_behaves_like "extracting thumbnail doc file"
  end

  describe "from URL with parameters" do
    let(:target) { "http://www.example.com/file.doc?auth_token=nA33sfkjw3sxz" }
    it_behaves_like "extracting thumbnail doc file"
  end

  context "failing when trying to extract" do
    def extraction_should_fail(name)
      expect { ExtensionThumbnailExtractor.new(name).extract }.to raise_error
    end

    it "unsupported extension" do
      extraction_should_fail("unsupported.xyz")
    end

    it "from name without extension" do
      extraction_should_fail("without_extension")
    end
  end

  it "should have a constructor method" do
    extractor = spy('ExtensionThumbnailExtractor')
    name = 'file.doc'
    allow(ExtensionThumbnailExtractor).to receive(:new).with(name).and_return(extractor)
    ExtensionThumbnailExtractor.extract(name)
    expect(extractor).to have_received(:extract)
  end
end
