desc 'Clean stale attachment older than 1 month'
task clean_attachments: :environment do
  StaleAttachmentDestroyer.new.run
end
