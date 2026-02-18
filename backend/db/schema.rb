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

ActiveRecord::Schema[8.1].define(version: 2026_02_17_235610) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "request_logs", force: :cascade do |t|
    t.integer "completion_tokens"
    t.datetime "created_at", null: false
    t.float "latency"
    t.text "llm_response"
    t.text "original_prompt"
    t.integer "prompt_tokens"
    t.string "provider"
    t.text "sanitized_prompt"
    t.decimal "total_cost"
    t.datetime "updated_at", null: false
  end
end
