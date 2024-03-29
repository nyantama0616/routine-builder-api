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

ActiveRecord::Schema[7.0].define(version: 2024_03_25_034614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caterpillars", force: :cascade do |t|
    t.bigint "life_id", null: false
    t.string "pattern", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["life_id"], name: "index_caterpillars_on_life_id"
  end

  create_table "hiits", force: :cascade do |t|
    t.bigint "life_id", null: false
    t.integer "work_time", null: false
    t.integer "break_time", null: false
    t.integer "round_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["life_id"], name: "index_hiits_on_life_id"
  end

  create_table "lives", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "water", default: 0, null: false
  end

  create_table "sleeps", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.boolean "nap", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "life_id", null: false
    t.index ["life_id"], name: "index_sleeps_on_life_id"
  end

  create_table "timers", force: :cascade do |t|
    t.boolean "running", default: false, null: false
    t.integer "passed_seconds_when_stopped", default: 0, null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "target_type"
    t.bigint "target_id"
    t.index ["target_type", "target_id"], name: "index_timers_on_target"
  end

  add_foreign_key "caterpillars", "lives"
  add_foreign_key "hiits", "lives"
  add_foreign_key "sleeps", "lives"
end
