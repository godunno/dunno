class CleanMedias
  def self.clean!
    Media.where(topic: nil).find_each(&:destroy!)
  end
end
