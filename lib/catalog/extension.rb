module Catalog
  class Extension
    def self.from(name)
      new(name).name
    end

    def initialize(name)
      @name = name
    end

    def name
      File.extname(URI.parse(@name).path).sub('.', '') rescue nil
    end
  end
end
