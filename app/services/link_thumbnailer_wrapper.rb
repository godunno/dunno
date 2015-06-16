class LinkThumbnailerWrapper
  attr_accessor :url

  def initialize(url)
    self.url = url
  end

  def generate
    parse_link
  rescue SocketError, Net::HTTP::Persistent::Error, Net::OpenTimeout
    Hashie::Mash.new(title: url, images: [])
  end

  def self.generate(url)
    new(url).generate
  end

  private
  def parse_link
    return image_as_link if image?
    LinkThumbnailer.generate(url)
  end

  def image_as_link
    Hashie::Mash.new(title: url, images: [src: url])
  end

  def image?
    FastImage.type(url)
  end
end
