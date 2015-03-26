class NotificationFormatter
  attr_reader :message

  def self.format(message)
    new(message).format
  end

  def initialize(message)
    @message = message
  end

  def format
    I18n.transliterate(message)
  end
end
