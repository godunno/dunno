require 'spec_helper'

describe LinkThumbnailerWrapper do
  it "should be able to receive image", :vcr do
    url = "http://placehold.it/350x150"
    link_thumbnailer = LinkThumbnailerWrapper.new(url)
    result = nil
    expect { result = link_thumbnailer.generate }.not_to raise_error
    expect(result.title).to eq(url)
    expect(result.images[0].src).to eq(url)
  end

  it "should be able to receive non existent URL", :vcr do
    url = "http://www.nao-existe.com"
    link_thumbnailer = LinkThumbnailerWrapper.new(url)
    result = nil
    expect { result = link_thumbnailer.generate }.not_to raise_error
    expect(result.title).to eq(url)
  end

  it "should use the LinkThumbnailer" do
    url = "http://www.google.com"
    expect(LinkThumbnailer).to receive(:generate).with(url)
    LinkThumbnailerWrapper.new(url).generate
  end

  it "should have a constructor method" do
    wrapper = spy('LinkThumbnailerWrapper')
    url = "http://www.google.com"
    allow(LinkThumbnailerWrapper).to receive(:new).with(url).and_return(wrapper)
    LinkThumbnailerWrapper.generate(url)
    expect(wrapper).to have_received(:generate)
  end
end
