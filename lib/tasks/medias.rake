namespace :medias do
  desc 'Clean unreferenced medias'
  task clean: :environment do
    puts "Cleaning medias..."

    count_before = Media.count
    CleanMedias.clean!

    puts "Finished!"
    puts "#{count_before - Media.count} medias deleted"
  end
end
