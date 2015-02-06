require 'spec_helper'

describe ExtensionThumbnailExtractor do
  context "extracting" do
    subject { ExtensionThumbnailExtractor.new(target).extract }

    describe "from filename" do
      let(:target) { "file.doc" }
      it { expect(subject.extension).to eq("doc") }
      it { expect(subject.path).to eq("/assets/extensions/doc.png") }
    end

    describe "from file path" do
      let(:target) { "/path/to/file/file.doc" }
      it { expect(subject.extension).to eq("doc") }
      it { expect(subject.path).to eq("/assets/extensions/doc.png") }
    end
  end

  context "failing when trying to extract" do
    it "unsupported extension" do
      expect { ExtensionThumbnailExtractor.new("unsupported.xyz").extract }.to raise_error
    end

    it "from name without extension" do
      expect { ExtensionThumbnailExtractor.new("without_extension").extract }.to raise_error
    end
  end
end
