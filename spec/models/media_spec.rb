require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:mediable) }
    it { should belong_to(:profile) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
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

  describe ".search_by_profile", :elasticsearch do
    let(:profile) { create(:profile) }
    let!(:old_media) { create(:media, profile: profile, title: "Another Title", tag_list: %w(cool stuff)) }
    let!(:new_media) { create(:media, profile: profile, title: "Some Title") }
    let!(:media_from_another_profile) { create(:media) }

    before { refresh_index! }

    it "can set a number of items per page" do
      expect(Media.search_by_profile(profile, per_page: 1).records.to_a).to eq([new_media])
    end

    it "paginates" do
      expect(Media.search_by_profile(profile, per_page: 1, page: 2).records.to_a).to eq([old_media])
    end

    it "orders all from newest to oldest" do
      expect(Media.search_by_profile(profile, {}).records.to_a).to eq([new_media, old_media])
    end

    it "searches by title" do
      expect(Media.search_by_profile(profile, q: "Some").records.to_a).to eq([new_media])
    end

    it "searches by tag" do
      expect(Media.search_by_profile(profile, q: "cool").records.to_a).to eq([old_media])
    end
  end
end
