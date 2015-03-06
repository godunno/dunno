require 'spec_helper'
require 'webmock/rspec'

describe Form::MediaForm do

  let(:media) { attributes_for :media }
  let(:media_form) { Form::MediaForm.new media }

  describe "validations" do

    it "should validate URL's format" do
      allow(LinkThumbnailer).to receive(:generate).and_return(double("LinkThumbnailer", as_json: spy("preview"), title: "Title", description: "", images: []))
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
      media_form.file_url = nil
      media_form.url = 'http://www.example.com'
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 0
      expect(media_form.errors[:file_url].size).to eq 0

      media_form.file_url = "document.doc"
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 1
      expect(media_form.errors[:file_url].size).to eq 1

      media_form.url = nil
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 0
      expect(media_form.errors[:file_url].size).to eq 0
    end

    it "should have URL or File presence" do
      media_form.file_url = nil
      media_form.url = nil
      media_form.valid?
      expect(media_form.errors[:url].size).to eq 1
      expect(media_form.errors[:file_url].size).to eq 1
    end
  end

  it "should truncate too long descriptions" do
    long_description = "a" * 256
    allow(LinkThumbnailer).to(
      receive(:generate).and_return(
        double("preview", title: "Title", description: long_description, images: [])
      )
    )
    media_form = Form::MediaForm.new(attributes_for(:media_with_url))
    expect { media_form.save! }.not_to raise_error
    expect(media_form.description).to eq("#{long_description[0..251]}...")
  end

  it "should remove leading and trailing whitespaces from URL" do
    media[:url] = url = " http://www.example.com  "
    allow(LinkThumbnailerWrapper).to receive(:generate).with(url).and_return(double("preview", title: "Title", description: "", images: []))
    media_form = nil
    expect { media_form = Form::MediaForm.new(media) }.not_to raise_error
    expect(media_form.url).to eq("http://www.example.com")
  end

  it "should be able to link to image", :vcr do
    media[:url] = url = "http://placehold.it/350x150"
    media_form = nil
    expect { media_form = Form::MediaForm.new(media) }.not_to raise_error
    expect(media_form.thumbnail).to eq(url)
  end

  it "should use the LinkThumbnailerWrapper for url medias" do
    media[:url] = url = "http://www.google.com"
    expect(LinkThumbnailerWrapper).to receive(:generate).with(url).and_return(double("preview", title: "Title", description: "", images: []))
    Form::MediaForm.new(media)
  end

  it "should extract the thumbnail" do
    extractor = spy("ThumbnailExtractor")
    allow(Catalog::ThumbnailExtractor).to receive(:new).and_return(extractor)
    Form::MediaForm.new(media)
    expect(extractor).to have_received(:extract)
  end
end
