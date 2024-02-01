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

ActiveRecord::Schema[7.0].define(version: 2024_01_31_161036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "addresses", force: :cascade do |t|
    t.string "line1"
    t.string "line2"
    t.string "zipcode"
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "country"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "airs", force: :cascade do |t|
    t.string "title"
    t.integer "length_minutes"
    t.string "composer"
    t.string "oeuvre"
    t.string "character"
    t.string "tonality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "imposed_work_id"
    t.bigint "choice_imposed_work_id"
    t.bigint "semi_imposed_work_id"
    t.text "infos"
    t.index ["choice_imposed_work_id"], name: "index_airs_on_choice_imposed_work_id"
    t.index ["imposed_work_id"], name: "index_airs_on_imposed_work_id"
    t.index ["semi_imposed_work_id"], name: "index_airs_on_semi_imposed_work_id"
  end

  create_table "candidate_program_airs", force: :cascade do |t|
    t.bigint "candidate_program_id", null: false
    t.bigint "air_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["air_id"], name: "index_candidate_program_airs_on_air_id"
    t.index ["candidate_program_id"], name: "index_candidate_program_airs_on_candidate_program_id"
  end

  create_table "candidate_programs", force: :cascade do |t|
    t.bigint "inscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inscription_id"], name: "index_candidate_programs_on_inscription_id"
  end

  create_table "candidats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "cv"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "nationality"
    t.date "birthdate"
    t.text "short_bio"
    t.text "medium_bio"
    t.text "long_bio"
    t.text "repertoire"
    t.index ["user_id"], name: "index_candidats_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "edition_competition_id", null: false
    t.string "name"
    t.text "description"
    t.integer "min_age"
    t.integer "max_age"
    t.integer "discipline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.integer "status", default: 0
    t.boolean "allow_own_pianist_accompagnateur"
    t.index ["edition_competition_id"], name: "index_categories_on_edition_competition_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "choice_imposed_work_airs", force: :cascade do |t|
    t.bigint "choice_imposed_work_id", null: false
    t.bigint "air_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inscription_id", null: false
    t.index ["air_id"], name: "index_choice_imposed_work_airs_on_air_id"
    t.index ["choice_imposed_work_id"], name: "index_choice_imposed_work_airs_on_choice_imposed_work_id"
    t.index ["inscription_id"], name: "index_choice_imposed_work_airs_on_inscription_id"
  end

  create_table "choice_imposed_works", force: :cascade do |t|
    t.string "title"
    t.text "guidelines"
    t.integer "number_to_select"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_choice_imposed_works_on_category_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.bigint "organism_id", null: false
    t.string "nom_concours"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["organism_id"], name: "index_competitions_on_organism_id"
    t.index ["slug"], name: "index_competitions_on_slug", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.integer "document_type"
    t.string "file_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "parent_type", null: false
    t.bigint "parent_id", null: false
    t.index ["parent_type", "parent_id"], name: "index_documents_on_parent"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "edition_competitions", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.integer "annee"
    t.text "details_specifiques"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_of_registration"
    t.date "start_date"
    t.date "end_date"
    t.string "reglement_url"
    t.integer "status", default: 0
    t.index ["competition_id"], name: "index_edition_competitions_on_competition_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.bigint "candidat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidat_id"], name: "index_educations_on_candidat_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.bigint "candidat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidat_id"], name: "index_experiences_on_candidat_id"
  end

  create_table "free_choice_airs", force: :cascade do |t|
    t.bigint "free_choice_id", null: false
    t.bigint "air_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["air_id"], name: "index_free_choice_airs_on_air_id"
    t.index ["free_choice_id"], name: "index_free_choice_airs_on_free_choice_id"
  end

  create_table "free_choices", force: :cascade do |t|
    t.integer "number"
    t.integer "max_length_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_free_choices_on_category_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "imposed_works", force: :cascade do |t|
    t.string "title"
    t.text "guidelines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_imposed_works_on_category_id"
  end

  create_table "inscription_item_requirements", force: :cascade do |t|
    t.bigint "inscription_id", null: false
    t.bigint "requirement_item_id", null: false
    t.text "submitted_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "verification_status", default: 0
    t.index ["inscription_id"], name: "index_inscription_item_requirements_on_inscription_id"
    t.index ["requirement_item_id"], name: "index_inscription_item_requirements_on_requirement_item_id"
  end

  create_table "inscription_orders", force: :cascade do |t|
    t.integer "state", default: 0
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.bigint "inscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.index ["inscription_id"], name: "index_inscription_orders_on_inscription_id"
    t.index ["user_id"], name: "index_inscription_orders_on_user_id"
  end

  create_table "inscriptions", force: :cascade do |t|
    t.bigint "candidat_id", null: false
    t.bigint "category_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.boolean "candidate_brings_pianist_accompagnateur"
    t.index ["candidat_id"], name: "index_inscriptions_on_candidat_id"
    t.index ["category_id"], name: "index_inscriptions_on_category_id"
  end

  create_table "jures", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "autres_informations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_jures_on_user_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisateurs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "nom_organisme"
    t.text "description_organisme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_organisateurs_on_user_id"
  end

  create_table "organisms", force: :cascade do |t|
    t.bigint "organisateur_id", null: false
    t.string "nom"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["organisateur_id"], name: "index_organisms_on_organisateur_id"
    t.index ["slug"], name: "index_organisms_on_slug", unique: true
  end

  create_table "partners", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organism_id", null: false
    t.string "role_partenaire"
    t.string "niveau_autorisation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organism_id"], name: "index_partners_on_organism_id"
    t.index ["user_id"], name: "index_partners_on_user_id"
  end

  create_table "pauses", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.date "date"
    t.bigint "tour_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_pauses_on_tour_id"
  end

  create_table "performances", force: :cascade do |t|
    t.bigint "inscription_id", null: false
    t.bigint "tour_id", null: false
    t.datetime "start_time"
    t.text "resultat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "air_selection", default: [], array: true
    t.integer "order"
    t.date "start_date"
    t.boolean "is_qualified", default: false
    t.integer "status", default: 0
    t.text "ordered_air_selection", default: [], array: true
    t.bigint "pianist_accompagnateur_id"
    t.index ["inscription_id"], name: "index_performances_on_inscription_id"
    t.index ["pianist_accompagnateur_id"], name: "index_performances_on_pianist_accompagnateur_id"
    t.index ["tour_id"], name: "index_performances_on_tour_id"
  end

  create_table "pianist_accompagnateurs", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organism_id", null: false
    t.index ["organism_id"], name: "index_pianist_accompagnateurs_on_organism_id"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "title"
    t.integer "amount"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_prizes_on_category_id"
  end

  create_table "programme_requirements", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_programme_requirements_on_category_id"
  end

  create_table "requirement_items", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.integer "type_item"
    t.text "description_item"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_requirement_items_on_category_id"
  end

  create_table "semi_imposed_work_airs", force: :cascade do |t|
    t.bigint "semi_imposed_work_id", null: false
    t.bigint "air_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inscription_id", null: false
    t.index ["air_id"], name: "index_semi_imposed_work_airs_on_air_id"
    t.index ["inscription_id"], name: "index_semi_imposed_work_airs_on_inscription_id"
    t.index ["semi_imposed_work_id"], name: "index_semi_imposed_work_airs_on_semi_imposed_work_id"
  end

  create_table "semi_imposed_works", force: :cascade do |t|
    t.text "guidelines"
    t.integer "number"
    t.integer "max_length_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.string "title"
    t.index ["category_id"], name: "index_semi_imposed_works_on_category_id"
  end

  create_table "tour_requirements", force: :cascade do |t|
    t.text "description"
    t.integer "min_number_of_works"
    t.integer "max_number_of_works"
    t.integer "min_duration_minute"
    t.integer "max_duration_minute"
    t.bigint "tour_id", null: false
    t.boolean "organiser_creates_program"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_tour_requirements_on_tour_id"
  end

  create_table "tours", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "start_date"
    t.datetime "start_time"
    t.datetime "end_date"
    t.datetime "end_time"
    t.boolean "is_online"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minutes_max_per_performance"
    t.datetime "max_end_of_day_time"
    t.datetime "new_day_start_time"
    t.boolean "is_finished", default: false
    t.integer "tour_number", default: 1
    t.datetime "final_performance_submission_deadline"
    t.text "imposed_air_selection", default: [], array: true
    t.boolean "no_pianist_accompagnateur"
    t.index ["category_id"], name: "index_tours_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inscription_role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "airs", "choice_imposed_works"
  add_foreign_key "airs", "imposed_works"
  add_foreign_key "airs", "semi_imposed_works"
  add_foreign_key "candidate_program_airs", "airs"
  add_foreign_key "candidate_program_airs", "candidate_programs"
  add_foreign_key "candidate_programs", "inscriptions"
  add_foreign_key "candidats", "users"
  add_foreign_key "categories", "edition_competitions"
  add_foreign_key "choice_imposed_work_airs", "airs"
  add_foreign_key "choice_imposed_work_airs", "choice_imposed_works"
  add_foreign_key "choice_imposed_work_airs", "inscriptions"
  add_foreign_key "choice_imposed_works", "categories"
  add_foreign_key "competitions", "organisms"
  add_foreign_key "documents", "users"
  add_foreign_key "edition_competitions", "competitions"
  add_foreign_key "educations", "candidats"
  add_foreign_key "experiences", "candidats"
  add_foreign_key "free_choice_airs", "airs"
  add_foreign_key "free_choice_airs", "free_choices"
  add_foreign_key "free_choices", "categories"
  add_foreign_key "imposed_works", "categories"
  add_foreign_key "inscription_item_requirements", "inscriptions"
  add_foreign_key "inscription_item_requirements", "requirement_items"
  add_foreign_key "inscription_orders", "inscriptions"
  add_foreign_key "inscription_orders", "users"
  add_foreign_key "inscriptions", "candidats"
  add_foreign_key "inscriptions", "categories"
  add_foreign_key "jures", "users"
  add_foreign_key "organisateurs", "users"
  add_foreign_key "organisms", "organisateurs"
  add_foreign_key "partners", "organisms"
  add_foreign_key "partners", "users"
  add_foreign_key "pauses", "tours"
  add_foreign_key "performances", "inscriptions"
  add_foreign_key "performances", "pianist_accompagnateurs"
  add_foreign_key "performances", "tours"
  add_foreign_key "pianist_accompagnateurs", "organisms"
  add_foreign_key "prizes", "categories"
  add_foreign_key "programme_requirements", "categories"
  add_foreign_key "requirement_items", "categories"
  add_foreign_key "semi_imposed_work_airs", "airs"
  add_foreign_key "semi_imposed_work_airs", "inscriptions"
  add_foreign_key "semi_imposed_work_airs", "semi_imposed_works"
  add_foreign_key "semi_imposed_works", "categories"
  add_foreign_key "tour_requirements", "tours"
  add_foreign_key "tours", "categories"
end
