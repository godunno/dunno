json.root_path(dashboard_path)
json.(@resource, :id, :name, :email, :phone_number, :authentication_token)
# TODO: use helper
json.created_at(@resource.created_at.utc.iso8601)
json.profile(@resource.profile_name)
json.courses_count(@resource.profile.courses.count)
json.courses(@resource.profile.courses.map(&:access_code))
