json.course do
  json.(@course, :name, :class_name, :institution)

  json.teacher do
    json.(@course.teacher, :name)
  end
end
