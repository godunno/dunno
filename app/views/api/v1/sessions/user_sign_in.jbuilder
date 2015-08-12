json.root_path(dashboard_path)
json.(@resource, :id, :name, :phone_number, :email, :authentication_token, :completed_tutorial)
# TODO: use helper
json.created_at(@resource.created_at.utc.iso8601)
json.profile(@resource.profile_name)
json.courses_count(@resource.profile.courses.count)
json.students_count(@resource.profile.students_count)
json.notifications_count(@resource.profile.notifications_count)
