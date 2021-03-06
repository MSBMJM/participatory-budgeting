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

ActiveRecord::Schema.define(version: 20181118232811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",                                                    null: false
    t.text     "description",                                              null: false
    t.decimal  "budget",          precision: 10, scale: 2,                 null: false
    t.date     "start_date",                                               null: false
    t.date     "end_date",                                                 null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "active",                                   default: false, null: false
    t.integer  "constituency_id"
    t.index ["constituency_id"], name: "index_campaigns_on_constituency_id", using: :btree
  end

  create_table "classifiers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifiers_proposals", id: false, force: :cascade do |t|
    t.integer "classifier_id"
    t.integer "proposal_id"
    t.index ["classifier_id"], name: "index_classifiers_proposals_on_classifier_id", using: :btree
    t.index ["proposal_id", "classifier_id"], name: "index_classifiers_proposals_on_proposal_id_and_classifier_id", unique: true, using: :btree
    t.index ["proposal_id"], name: "index_classifiers_proposals_on_proposal_id", using: :btree
  end

  create_table "classifiers_suggestions", id: false, force: :cascade do |t|
    t.integer "classifier_id"
    t.integer "suggestion_id"
    t.index ["classifier_id"], name: "index_classifiers_suggestions_on_classifier_id", using: :btree
    t.index ["suggestion_id", "classifier_id"], name: "index_suggestion_id_and_classifier_id", unique: true, using: :btree
    t.index ["suggestion_id"], name: "index_classifiers_suggestions_on_suggestion_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "text",          null: false
    t.integer  "voter_id"
    t.integer  "comment_id"
    t.integer  "proposal_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "suggestion_id"
    t.index ["comment_id"], name: "index_comments_on_comment_id", using: :btree
    t.index ["proposal_id"], name: "index_comments_on_proposal_id", using: :btree
    t.index ["suggestion_id"], name: "index_comments_on_suggestion_id", using: :btree
    t.index ["voter_id"], name: "index_comments_on_voter_id", using: :btree
  end

  create_table "constituencies", force: :cascade do |t|
    t.string   "title",                       null: false
    t.text     "description",                 null: false
    t.boolean  "active",      default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.string   "title",                                                null: false
    t.text     "description",                                          null: false
    t.decimal  "budget",      precision: 10, scale: 2,                 null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "completed",                            default: false, null: false
    t.integer  "campaign_id"
    t.text     "image_data"
    t.index ["campaign_id"], name: "index_proposals_on_campaign_id", using: :btree
  end

  create_table "proposals_voters", id: false, force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "voter_id"
    t.index ["proposal_id"], name: "index_proposals_voters_on_proposal_id", using: :btree
    t.index ["voter_id", "proposal_id"], name: "index_proposals_voters_on_voter_id_and_proposal_id", unique: true, using: :btree
    t.index ["voter_id"], name: "index_proposals_voters_on_voter_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string "email", null: false
    t.index ["email"], name: "index_roles_on_email", unique: true, using: :btree
  end

  create_table "suggestions", force: :cascade do |t|
    t.string   "title",                                                         null: false
    t.text     "description",                                                   null: false
    t.decimal  "budget",           precision: 10, scale: 2
    t.text     "image_data"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "campaign_id"
    t.text     "proposing_member"
    t.boolean  "approved"
    t.boolean  "reviewed"
    t.string   "review_status",                             default: "waiting"
    t.text     "solution"
    t.text     "contact"
    t.index ["campaign_id"], name: "index_suggestions_on_campaign_id", using: :btree
  end

  create_table "voter_secrets", force: :cascade do |t|
    t.hstore   "data",       default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["data"], name: "index_voter_secrets_on_data", using: :gin
  end

  create_table "voters", force: :cascade do |t|
    t.string   "email",                              null: false
    t.boolean  "verified",           default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "verification_token"
    t.string   "name"
    t.text     "access_ids"
    t.text     "voted_campaigns",    default: ""
    t.index ["email"], name: "index_voters_on_email", unique: true, using: :btree
    t.index ["verification_token"], name: "index_voters_on_verification_token", unique: true, using: :btree
  end

  add_foreign_key "campaigns", "constituencies"
  add_foreign_key "classifiers_proposals", "classifiers"
  add_foreign_key "classifiers_proposals", "proposals"
  add_foreign_key "classifiers_suggestions", "classifiers"
  add_foreign_key "classifiers_suggestions", "suggestions"
  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "proposals"
  add_foreign_key "comments", "suggestions"
  add_foreign_key "comments", "voters"
  add_foreign_key "proposals", "campaigns"
  add_foreign_key "proposals_voters", "proposals"
  add_foreign_key "proposals_voters", "voters"
  add_foreign_key "suggestions", "campaigns"
end
