namespace :items do
  desc 'Report topics with URLs'
  task topics_with_url: :environment do
    puts "Calculating..."

    report = ReportUrlOnItems.new(Topic)
    puts "Topics with URL on description: #{report.with_url.count}"
    puts "Total topics: #{Topic.count}"
    puts "Percentage of topics with URL on description: %.2f%" % (report.with_url.count.to_f / Topic.count)
    puts
    puts "Teachers using topics with URL on description: #{report.teachers_using_url.count}"
    puts "Total teachers: #{Teacher.count}"
    puts "Percentage of teachers using topics with URL on description: %.2f%" % (report.teachers_using_url.count.to_f / Teacher.count)
    puts "\nFinished!"
  end

  desc 'Report personal notes with URLs'
  task personal_notes_with_url: :environment do
    puts "Calculating..."

    report = ReportUrlOnItems.new(PersonalNote)
    puts "Personal notes with URL on description: #{report.with_url.count}"
    puts "Total personal notes: #{PersonalNote.count}"
    puts "Percentage of personal notes with URL on description: %.2f%" % (report.with_url.count.to_f / PersonalNote.count)
    puts
    puts "Teachers using personal notes with URL on description: #{report.teachers_using_url.count}"
    puts "Total teachers: #{Teacher.count}"
    puts "Percentage of teachers using personal notes with URL on description: %.2f%" % (report.teachers_using_url.count.to_f / Teacher.count)
    puts "\nFinished!"
  end
end
