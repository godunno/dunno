json.course do
  json.(@course, :uuid, :access_code, :name, :class_name, :institution)

  json.teacher do
    json.(@course.teacher, :name)
  end
end
