require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:mediable) }
    it { should belong_to(:teacher) }
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

  describe "::search", :elasticsearch do
    let!(:old_media) { create :media }
    let!(:new_media) { create :media }

    before { refresh_index! }

    it "should be ordered from newest to oldest" do
      expect(Media.search.records.to_a).to eq([new_media, old_media])
    end

    it "can set a number of items per page" do
      expect(Media.search(per_page: 1).records.to_a).to eq([new_media])
    end

    describe "filter by" do
      let!(:teacher) { create(:teacher) }
      let!(:course) { create(:course, teacher: teacher) }
      let!(:event) { create(:event, course: course) }
      let!(:topic) { create(:topic, event: event) }
      let!(:media) { create(:media, topics: [topic], teacher: teacher) }

      before { refresh_index! }

      describe "teacher_id" do
        it do
          expect(Media.search(filter: { teacher_id: teacher.id }).records.to_a).to eq([media])
        end
      end

      describe "course_id" do
        it do
          expect(Media.search(filter: { course_uuid: course.uuid }).records.to_a).to eq([media])
        end
      end
    end
  end
end
