class AddTimestampsToNotifications < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      add_timestamps(:notifications)
      Notification.find_each do |notification|
        notification.created_at = notification.updated_at = Time.zone.now
        notification.save(validate: false)
      end
    end
  end
end
