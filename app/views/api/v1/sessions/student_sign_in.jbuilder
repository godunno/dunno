json.root_path(dashboard_student_path)
json.(@resource, :id, :name, :email, :phone_number, :authentication_token)
json.courses(@resource.profile.courses.map(&:access_code))
