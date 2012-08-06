# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100212002023) do

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "href"
    t.string   "icon"
    t.string   "panel"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.integer  "garage_sign",         :default => 0
    t.integer  "west_flood",          :default => 0
    t.integer  "west_entry",          :default => 0
    t.integer  "balcony",             :default => 0
    t.integer  "garage_interior",     :default => 0
    t.integer  "living_dimmer",       :default => 0
    t.integer  "dining_dimmer",       :default => 0
    t.integer  "stairs",              :default => 0
    t.integer  "loft",                :default => 0
    t.integer  "ac_pwm_a",            :default => 0
    t.float    "thermostat_main",     :default => 0.0, :null => false
    t.float    "thermostat_loft",     :default => 0.0, :null => false
    t.float    "thermostat_bathroom", :default => 0.0, :null => false
    t.float    "thermostat_garage",   :default => 0.0, :null => false
    t.integer  "kitchen",             :default => 0
    t.integer  "hallway",             :default => 0
    t.integer  "bathroom",            :default => 0
    t.integer  "bathroom_mirror",     :default => 0
    t.integer  "bedside_lamps",       :default => 0
  end

  create_table "residents", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
