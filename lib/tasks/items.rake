namespace :items do
  desc 'Report topics and personal notes with URL on their descriptions'
  task with_url: :environment do
    puts "Calculating..."

    [Topic, PersonalNote].each do |klass|
      report = ReportUrlOnItems.new(klass)
      plural = klass.model_name.plural.gsub('_', ' ')
      puts "\n=============== #{plural.upcase} ==============="
      puts "#{plural.capitalize} with URL on description: #{report.with_url.count}"
      puts "Total #{plural}: #{klass.count}"
      puts "Percentage of #{plural} with URL on description: %.2f%" % (report.with_url.count.to_f / klass.count)
      puts
      puts "Teachers using #{plural} with URL on description: #{report.teachers_using_url.count}"
      puts "Total teachers: #{Teacher.count}"
      puts "Percentage of teachers using #{plural} with URL on description: %.2f%" % (report.teachers_using_url.count.to_f / Teacher.count)
    end
    puts "\nFinished!"
  end
end
