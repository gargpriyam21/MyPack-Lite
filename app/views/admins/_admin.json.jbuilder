json.extract! admin, :id, :admin_id, :password, :name, :email, :phone_number, :created_at, :updated_at
json.url admin_url(admin, format: :json)
