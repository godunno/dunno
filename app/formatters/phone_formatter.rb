class PhoneFormatter
  FORMAT = "+%c %a %n"
  attr_accessor :number

  def initialize(number)
    self.number = number
  end

  def format
    Phonie::Phone.parse(number, country_code:  "55").format(FORMAT)
  end

  def self.format(number)
    new(number).format
  end
end
