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

ActiveRecord::Schema[8.0].define(version: 2025_02_10_010251) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_announcements_on_code", unique: true
    t.index ["event_id"], name: "index_announcements_on_event_id"
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_keywords", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_keywords_on_category_id"
    t.index ["keyword_id"], name: "index_category_keywords_on_keyword_id"
  end

  create_table "event_categories", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_event_categories_on_category_id"
    t.index ["event_id"], name: "index_event_categories_on_event_id"
  end

  create_table "event_place_recommendations", force: :cascade do |t|
    t.string "name"
    t.string "full_address"
    t.string "phone"
    t.integer "event_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_place_id"], name: "index_event_place_recommendations_on_event_place_id"
  end

  create_table "event_places", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "zip_code"
    t.string "state"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_event_places_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.integer "event_type"
    t.integer "participants_limit"
    t.string "url"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "code", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "event_place_id"
    t.index ["code"], name: "index_events_on_code"
    t.index ["discarded_at"], name: "index_events_on_discarded_at"
    t.index ["event_place_id"], name: "index_events_on_event_place_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_keywords_on_value", unique: true
  end

  create_table "schedule_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "responsible_name"
    t.string "responsible_email"
    t.integer "schedule_type"
    t.integer "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code", null: false
    t.datetime "discarded_at"
    t.index ["code"], name: "index_schedule_items_on_code", unique: true
    t.index ["discarded_at"], name: "index_schedule_items_on_discarded_at"
    t.index ["schedule_id"], name: "index_schedule_items_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "date"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_speakers_on_code", unique: true
    t.index ["email"], name: "index_speakers_on_email", unique: true
  end

  create_table "ticket_batches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "tickets_limit", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.decimal "ticket_price", precision: 10, scale: 2, null: false
    t.integer "discount_option"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_ticket_batches_on_code"
    t.index ["event_id"], name: "index_ticket_batches_on_event_id"
  end

  create_table "user_addresses", force: :cascade do |t|
    t.string "street"
    t.integer "number"
    t.string "district"
    t.string "city"
    t.string "state", limit: 2
    t.string "zip_code"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "family_name"
    t.string "registration_number"
    t.integer "role", default: 1
    t.integer "verification_status"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "phone_number"
    t.string "id_photo"
    t.string "address_proof"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reviewed_by_id"
    t.integer "status", default: 1
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewed_by_id"], name: "index_verifications_on_reviewed_by_id"
    t.index ["user_id"], name: "index_verifications_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "events"
  add_foreign_key "announcements", "users"
  add_foreign_key "category_keywords", "categories"
  add_foreign_key "category_keywords", "keywords"
  add_foreign_key "event_categories", "categories"
  add_foreign_key "event_categories", "events"
  add_foreign_key "event_place_recommendations", "event_places"
  add_foreign_key "event_places", "users"
  add_foreign_key "events", "event_places"
  add_foreign_key "events", "users"
  add_foreign_key "schedule_items", "schedules"
  add_foreign_key "schedules", "events"
  add_foreign_key "ticket_batches", "events"
  add_foreign_key "user_addresses", "users"
  add_foreign_key "verifications", "users"
  add_foreign_key "verifications", "users", column: "reviewed_by_id"
end
