# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(
  email: "admin@ncsu.edu",
  user_role: "admin"
)

admin = Admin.create(
  admin_id: "1",
  name: 'Admin',
  email: 'admin@ncsu.edu',
  phone_number: '1234567890',
  password: '12345',
  user_id: user.id
)