require 'spec_helper'

describe Media do

  let(:media) { build(:media) }

  describe "associations" do
    it { should belong_to(:topic) }
    it { should belong_to(:personal_note) }
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

  describe "#preview" do
    it "generates preview from file" do
      media.file = uploaded_file("image.jpg", "image/jpeg")
      media.save!
      expect(media.preview).to eq(
        "url" => media.file.url,
        "title" => media.file_identifier
      )
    end
  end

end
