# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140819041205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "kind",           default: "home", null: false
    t.integer  "family_id"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name",                              null: false
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "web_site"
    t.string   "status",         default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.integer  "company_id", null: false
    t.string   "category"
    t.string   "name"
    t.string   "level"
    t.integer  "start_age"
    t.integer  "end_age"
    t.integer  "wday"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "studio"
    t.integer  "max_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
  end

  add_index "courses", ["company_id"], name: "index_courses_on_company_id", using: :btree

  create_table "courses_students", id: false, force: true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "families", force: true do |t|
    t.string   "name",                                null: false
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "home_phone"
    t.integer  "active",                  default: 1, null: false
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "families", ["company_id"], name: "index_families_on_company_id", using: :btree
  add_index "families", ["user_id"], name: "index_families_on_user_id", using: :btree

  create_table "guardians", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.integer  "family_id"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "email"
    t.integer  "active",       default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "family_id",                       null: false
    t.integer  "user_id"
    t.integer  "address_id"
    t.string   "mobile_phone"
    t.string   "email"
    t.date     "birth_date"
    t.string   "allergies"
    t.string   "medical_information"
    t.integer  "active",              default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["address_id"], name: "index_students_on_address_id", using: :btree
  add_index "students", ["family_id"], name: "index_students_on_family_id", using: :btree
  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "teachers", force: true do |t|
    t.integer  "company_id",                   null: false
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile_phone"
    t.string   "email"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "birth_date"
    t.boolean  "active",       default: true,  null: false
    t.boolean  "contractor",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teachers", ["company_id"], name: "index_teachers_on_company_id", using: :btree
  add_index "teachers", ["user_id"], name: "index_teachers_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "role"
    t.integer  "company_id"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "courses", "teachers", name: "courses_teacher_id_fk"

  add_foreign_key "courses_students", "courses", name: "courses_students_course_id_fk"
  add_foreign_key "courses_students", "students", name: "courses_students_student_id_fk"

  add_foreign_key "teachers", "companies", name: "teachers_company_id_fk"
  add_foreign_key "teachers", "users", name: "teachers_user_id_fk"

end
