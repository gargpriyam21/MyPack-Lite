json.extract! instructor, :id, :instructor_id, :name, :email, :password, :department, :created_at, :updated_at
json.url instructor_url(instructor, format: :json)
