require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  it_behaves_like "artifact"

  describe "associations" do
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:category) }
    it { should ensure_inclusion_of(:category).in_array(Media::CATEGORIES) }

    it "should validate URL's format" do
      media.url = "http://www.example.com"
      expect(media).to have(0).errors_on(:url)

      media.url = "invalid url"
      expect(media).to have(1).error_on(:url)
    end

    it "should make URL and File mutually exclusive" do
      media.file = nil
      media.url = 'http://www.example.com'
      expect(media).to have(0).errors_on(:url)

      media.file = Tempfile.new('test')
      expect(media).to have(1).error_on(:url)

      media.url = nil
      expect(media).to have(0).errors_on(:url)
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new media" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
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
