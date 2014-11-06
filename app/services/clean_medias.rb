class CleanMedias
  def self.clean!
    Media.where(topic: nil).where('created_at <= ?', 1.month.ago).find_each(&:destroy!)
  end
end
