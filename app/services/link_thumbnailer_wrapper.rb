class LinkThumbnailerWrapper
  attr_accessor :url

  def initialize(url)
    self.url = url
  end

  def generate
    LinkThumbnailer.generate(url)
  rescue ArgumentError
    Hashie::Mash.new(title: url, images: [src: url])
  end

  def self.generate(url)
    new(url).generate
  end
end
