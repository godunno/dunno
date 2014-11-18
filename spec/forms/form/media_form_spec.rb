require 'spec_helper'

describe Form::MediaForm do

  let(:media) { attributes_for :media }
  let(:media_form) { Form::MediaForm.new media }

  describe "validations" do

    it "should validate URL's format" do
      ["http://www.example.com", "http://example.com", "http://www.example.com/path/", "https://www.example.com"].each do |url|
        media_form.url = url
        expect(media_form).to be_valid
        expect(media_form.errors[:url].count).to eq(0)
      end

      ["ftp://path.com/file.doc", "www.example.com", "example.com", "example"].each do |url|
        media_form.url = url
        expect(media_form).not_to be_valid
        expect(media_form.errors[:url].count).to eq(1)
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
