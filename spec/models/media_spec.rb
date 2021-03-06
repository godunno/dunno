require 'spec_helper'

describe Media do
  let(:media) { build(:media) }

  describe "associations" do
    it { is_expected.to belong_to(:mediable) }
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to have_many(:topics).dependent(:destroy) }
    it { is_expected.to have_many(:events).through(:topics) }
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

  describe "indexing" do
    before do
      allow(IndexerWorker).to receive(:perform_async)
    end

    it { expect(Media.index_name).to eq 'test_medias' }

    context "creating" do
      it do
        media = create(:media)
        media.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Media", :index, media.id)
      end
    end

    context "updating" do
      let(:media) { create(:media, title: "Some title") }

      it do
        media.update!(title: "Another title")
        media.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Media", :index, media.id)
      end
    end

    context "destroying" do
      let(:media) { create(:media) }

      it do
        media.destroy!
        media.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Media", :delete, media.id)
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
    let!(:old_media) do
      create :media,
             profile: profile,
             title: "Another Title",
             tag_list: %w(cool stuff),
             created_at: 1.hour.ago
    end
    let!(:new_media) do
      create :media,
             profile: profile,
             title: "Some Title"
    end
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

  describe ".search_by_course", :elasticsearch do
    let(:course) { create(:course) }
    let(:another_course) { create(:course) }
    let!(:old_media) do
      create :media,
             title: "Another Title",
             tag_list: %w(cool stuff),
             created_at: 1.hour.ago,
             topics: [
               create(:topic, event: create(:event, :published, course: course)),
               create(:topic, event: create(:event, :published, course: another_course))
             ]
    end
    let!(:new_media) do
      create :media,
             title: "Some Title",
             topics: [
               create(:topic, event: create(:event, :published, course: course)),
               create(:topic, event: create(:event, :published, course: another_course))
             ]
    end
    let!(:media_from_another_profile) { create(:media) }
    let!(:media_from_another_course) do
      create :media,
             topics: [
               create(:topic, event: create(:event, :published, course: another_course))
             ]
    end
    let!(:media_from_unpublished_event) do
      create :media,
             topics: [
               create(:topic, event: create(:event, :draft, course: course))
             ]
    end

    before { refresh_index! }

    it "can set a number of items per page" do
      expect(Media.search_by_course(course, per_page: 1).records.to_a).to eq([new_media])
    end

    it "paginates" do
      expect(Media.search_by_course(course, per_page: 1, page: 2).records.to_a).to eq([old_media])
    end

    it "orders all from newest to oldest" do
      expect(Media.search_by_course(course, {}).records.to_a).to eq([new_media, old_media])
    end

    it "searches by title" do
      expect(Media.search_by_course(course, q: "Some").records.to_a).to eq([new_media])
    end

    it "searches by tag" do
      expect(Media.search_by_course(course, q: "cool").records.to_a).to eq([old_media])
    end
  end
end
