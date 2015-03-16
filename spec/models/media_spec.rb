require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:mediable) }
    it { should belong_to(:teacher) }
  end

  describe "callbacks" do
    describe "after create" do
      context "new media" do
        it "saves a new uuid" do
          expect(media.uuid).to be_nil
          media.save!
          expect(media.uuid).not_to be_nil
        end
      end
    end
  end

  describe "#release!" do
    before do
      Timecop.freeze
    end
    after { Timecop.return }

    it { expect {media.release!}.to change(media, :status).from("available").to("released") }
    it { expect {media.release!}.to change(media, :released_at).from(nil).to(Time.now) }
  end

  describe "#type" do
    context "file" do
      let(:media) { build :media_with_file }
      it { expect(media.type).to eq("file") }
    end

    context "url" do
      let(:media) { build :media_with_url }
      it { expect(media.type).to eq("url") }
    end

    context "empty" do
      let(:media) { build :media, file_url: nil, url: nil }
      it { expect(media.type).to be_nil }
    end
  end

  describe "#url" do
    context "it has file" do
      let(:media) { build :media_with_file }
      it { expect(URI(media.url).path).to eq(URI(media.file.url).path) }
    end
  end

  describe "#thumbnail" do
    let(:media) { build :media, thumbnail: saved_thumbnail }

    context "for images or links" do
      let(:thumb_url) { 'http://example.com/uploads/bla.jpg' }

      before do
        file = double('AwsFile')
        expect(AwsFile).to receive(:new).with(saved_thumbnail).and_return(file)
        expect(media).to receive(:file?).and_return(true)
        expect(file).to receive(:url).and_return(thumb_url)
      end

      context "it has a thumbnail with only a path" do
        let(:saved_thumbnail) { 'uploads/bla.jpeg' }

        it do
          expect(media.thumbnail).to eq thumb_url
        end
      end

      context "it has a thumbnail with a full url"
      let(:saved_thumbnail) { 'http://example.com/uploads/bla.jpg' }

      it do
        expect(media.thumbnail).to eq thumb_url
      end
    end

    context "it has an icon thumbnail" do
      let(:saved_thumbnail) { '/assets/thumbnails/file.png' }

      before do
        expect(media).to receive(:file?).and_return(true)
      end

      it do
        expect(media.thumbnail).to eq saved_thumbnail
      end
    end
  end

  describe "::search" do
    it "should be ordered from newest to oldest", :elasticsearch do
      old_media = create(:media)
      new_media = create(:media)
      refresh_index!
      expect(Media.search.records.to_a).to eq([new_media, old_media])
    end
  end
end
