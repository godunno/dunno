class TeachersImport < Importer
  header_rows 1

  def populate!(row)
    User.create!(
      name: row[0],
      email: row[1],
      phone_number: row[2],
      password: SecureRandom.hex(4),
      profile: Teacher.new
    )
  end
end
