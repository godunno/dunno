require 'spec_helper'
require 'webmock/rspec'

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

  it "should truncate too long descriptions" do
    long_description = "a" * 256
    allow(LinkThumbnailer).to(
      receive_message_chain(:generate, :as_json)
      .and_return(title: "Title", description: long_description, images: [])
    )
    media_form = Form::MediaForm.new(attributes_for(:media_with_url))
    expect { media_form.save! }.not_to raise_error
    expect(media_form.description).to eq("#{long_description[0..251]}...")
  end

  describe "thumbnail extraction" do
    it "should extract the thumbnail from the file extension" do
      media[:file] = uploaded_file("file.doc", "application/msword")
      path = "/assets/extensions/doc.png"
      expect_any_instance_of(ExtensionThumbnailExtractor::Thumbnail).to receive(:path).and_return(path)
      media_form = Form::MediaForm.new(media)
      expect(media_form.thumbnail).to eq(path)
    end

    it "should extract the thumbnail from the URL extension" do
      media[:url] = url = "http://www.example.com/file.doc"
      stub_request(:get, url).to_return(body: File.open("spec/fixtures/file.doc"))
      path = "/assets/extensions/doc.png"
      expect_any_instance_of(ExtensionThumbnailExtractor::Thumbnail).to receive(:path).and_return(path)
      media_form = Form::MediaForm.new(media)
      expect(media_form.thumbnail).to eq(path)
    end
  end
end
