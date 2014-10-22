require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:topic) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_inclusion_of(:category).in_array(Media::CATEGORIES) }

    it "should validate URL's format" do
      media.url = "http://www.example.com"
      media.valid?
      expect(media.errors[:url].size).to eq 0

      media.url = "invalid url"
      media.valid?
      expect(media.errors[:url].size).to eq 1
    end

    it "should make URL and File mutually exclusive" do
      media.file = nil
      media.url = 'http://www.example.com'
      media.valid?
      expect(media.errors[:url].size).to eq 0

      media.file = Tempfile.new('test')
      media.valid?
      expect(media.errors[:url].size).to eq 1

      media.url = nil
      media.valid?
      expect(media.errors[:url].size).to eq 0
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new media" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            media.save!
          end.to change{media.uuid}.from(nil).to(uuid)
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
end
