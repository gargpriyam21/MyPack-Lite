# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_02_05_233502) do
  create_table "admins", force: :cascade do |t|
    t.string "admin_id"
    t.string "password"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_admins_on_admin_id", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "instructor_name"
    t.string "weekdays"
    t.string "start_time"
    t.string "end_time"
    t.string "course_code"
    t.integer "capacity"
    t.integer "students_enrolled"
    t.integer "waitlist_capacity"
    t.integer "students_waitlisted"
    t.string "status"
    t.string "room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_code"], name: "index_courses_on_course_code", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.string "student_id"
    t.string "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructors", force: :cascade do |t|
    t.string "instructor_id"
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instructor_id"], name: "index_instructors_on_instructor_id", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "student_id"
    t.string "email"
    t.string "password"
    t.datetime "date_of_birth"
    t.string "phone_number"
    t.string "major"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_students_on_student_id", unique: true
  end

  create_table "waitlists", force: :cascade do |t|
    t.string "student_id"
    t.string "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
