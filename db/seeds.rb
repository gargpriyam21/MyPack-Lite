# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


admin = Admin.create(
  admin_id: "1",
  name: 'Admin',
  email: 'admin@mypack.com',
  phone_number: '911-911-9999',
  password: 'mypacklite'
)