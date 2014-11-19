require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:mediable) }
    it { should belong_to(:teacher) }
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
      let(:media) { build :media, file: nil, url: nil }
      it { expect(media.type).to be_nil }
    end
  end

  describe "#url" do
    context "it has file" do
      let(:media) { build :media_with_file }
      it { expect(media.url).to eq(media.file.url) }
    end
  end

end
