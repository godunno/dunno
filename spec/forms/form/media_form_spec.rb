require 'spec_helper'

describe Form::MediaForm do

  let(:media) { attributes_for :media }
  let(:media_form) { Form::MediaForm.new media }

  describe "validations" do

    it "should validate URL's format" do
      allow(LinkThumbnailer).to receive(:generate).and_return(double("LinkThumbnailer", as_json: spy("preview")))
      ["http://www.example.com", "http://example.com", "http://www.example.com/path/", "https://www.example.com", "www.example.com"].each do |url|
        media[:url] = url
        expect(Form::MediaForm.new(media)).to be_valid
      end

      ["ftp://path.com/file.doc", "example .com"].each do |url|
        media[:url] = url
        expect(Form::MediaForm.new(media)).not_to be_valid
      end
    end

    it "should make URL and File mutually exclusive" do
      media_form.file = nil
      media_form.url = 'http://www.example.com'
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 0
      expect(media_form.errors[:file].size).to eq 0

      media_form.file = uploaded_file("image.jpg", "image/jpeg")
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 1
      expect(media_form.errors[:file].size).to eq 1

      media_form.url = nil
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 0
      expect(media_form.errors[:file].size).to eq 0
    end

    it "should have URL or File presence" do
      media_form.file = nil
      media_form.url = nil
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 1
      expect(media_form.errors[:file].size).to eq 1
    end
  end
end
