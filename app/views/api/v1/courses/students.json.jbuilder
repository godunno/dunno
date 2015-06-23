json.array! @students do |student|
  StudentBuilder.new(student).build!(json)
end
