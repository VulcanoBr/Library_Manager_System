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

ActiveRecord::Schema[7.0].define(version: 2023_09_30_042403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zipcode"
    t.bigint "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_addresses_on_university_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "identification"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "email"
    t.bigint "nationality_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nationality_id"], name: "index_authors_on_nationality_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bookmarks_on_book_id"
    t.index ["student_id"], name: "index_bookmarks_on_student_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn"
    t.string "title"
    t.string "published"
    t.date "publication_date"
    t.string "edition"
    t.string "cover"
    t.text "summary"
    t.boolean "special_collection"
    t.integer "count", default: 0
    t.bigint "library_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "language_id", null: false
    t.bigint "publisher_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["language_id"], name: "index_books_on_language_id"
    t.index ["library_id"], name: "index_books_on_library_id"
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
    t.index ["subject_id"], name: "index_books_on_subject_id"
  end

  create_table "checkouts", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "book_id", null: false
    t.date "issue_date"
    t.date "expected_return_date"
    t.date "return_date"
    t.integer "validity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_checkouts_on_book_id"
    t.index ["student_id"], name: "index_checkouts_on_student_id"
  end

  create_table "education_levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hold_requests", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_hold_requests_on_book_id"
    t.index ["student_id"], name: "index_hold_requests_on_student_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "librarians", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "identification"
    t.string "password"
    t.string "phone"
    t.string "approved"
    t.bigint "library_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.index ["email"], name: "index_librarians_on_email", unique: true
    t.index ["library_id"], name: "index_librarians_on_library_id"
    t.index ["reset_password_token"], name: "index_librarians_on_reset_password_token", unique: true
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "location"
    t.integer "borrow_limit"
    t.float "overdue_fines"
    t.bigint "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_libraries_on_university_id"
  end

  create_table "nationalities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "special_books", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_special_books_on_book_id"
    t.index ["student_id"], name: "index_special_books_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
    t.string "identification"
    t.string "name"
    t.string "password"
    t.string "phone"
    t.integer "max_book_allowed", default: 0
    t.string "google_token"
    t.string "google_refresh_token"
    t.string "provider"
    t.string "uid"
    t.bigint "university_id", null: false
    t.bigint "education_level_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.index ["education_level_id"], name: "index_students_on_education_level_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
    t.index ["university_id"], name: "index_students_on_university_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telephones", force: :cascade do |t|
    t.string "phone"
    t.string "contact"
    t.string "email_contact"
    t.bigint "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_telephones_on_university_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "isbn"
    t.string "email"
    t.boolean "checkout"
    t.boolean "request"
    t.boolean "bookmarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "identification"
    t.string "homepage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "universities"
  add_foreign_key "authors", "nationalities"
  add_foreign_key "bookmarks", "books"
  add_foreign_key "bookmarks", "students"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "languages"
  add_foreign_key "books", "libraries"
  add_foreign_key "books", "publishers"
  add_foreign_key "books", "subjects"
  add_foreign_key "checkouts", "books"
  add_foreign_key "checkouts", "students"
  add_foreign_key "hold_requests", "books"
  add_foreign_key "hold_requests", "students"
  add_foreign_key "librarians", "libraries"
  add_foreign_key "libraries", "universities"
  add_foreign_key "special_books", "books"
  add_foreign_key "special_books", "students"
  add_foreign_key "students", "education_levels"
  add_foreign_key "students", "universities"
  add_foreign_key "telephones", "universities"
end
