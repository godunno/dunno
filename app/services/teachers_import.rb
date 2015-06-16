# TODO: change name
class TeachersImport
  attr_reader :url

  def self.import!(url)
    new(url).import!
  end

  def initialize(url)
    @url = url
  end

  def import!
    ActiveRecord::Base.transaction do
      SpreadsheetParser.parse(url, header_rows: 1).each do |row|
        User.create!(
          name: row[0],
          email: row[1],
          phone_number: row[2],
          password: SecureRandom.hex(4),
          profile: Profile.new
        )
      end
    end
  end
end
