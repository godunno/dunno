namespace :system_notifications do
  desc 'Deliver notifications digest for each user'
  task deliver_digests: :environment do
    DeliverDigests.new.deliver
  end
end

