class AddPresetFields < ActiveRecord::Migration
  def self.up
  	add_column :presets, :name, :text, :default => ""
  	add_column :presets, :garage_sign, :int, :default => 0
  	add_column :presets, :west_flood, :int, :default => 0
  	add_column :presets, :west_entry, :int, :default => 0
  	add_column :presets, :balcony, :int, :default => 0
  	add_column :presets, :garage_interior, :int, :default => 0
  	add_column :presets, :living_dimmer, :int, :default => 0
  	add_column :presets, :dining_dimmer, :int, :default => 0
  	add_column :presets, :stairs, :int, :default => 0
  	add_column :presets, :loft, :int, :default => 0
		add_column :presets, :ac_pwm_a, :int, :default => 0
  	add_column :presets, :thermostat_main, :int, :default => 0
  	add_column :presets, :thermostat_loft, :int, :default => 0
  	add_column :presets, :thermostat_bathroom, :int, :default => 0
  	add_column :presets, :thermostat_garage, :int, :default => 0
  end

  def self.down
  	remove_column :presets, :name
  	remove_column :presets, :garage_sign
  	remove_column :presets, :west_flood
  	remove_column :presets, :west_entry
  	remove_column :presets, :balcony
  	remove_column :presets, :garage_interior
  	remove_column :presets, :living_dimmer
  	remove_column :presets, :dining_dimmer
  	remove_column :presets, :stairs
  	remove_column :presets, :loft
		remove_column :presets, :ac_pwm_a
  	remove_column :presets, :thermostat_main
  	remove_column :presets, :thermostat_loft
  	remove_column :presets, :thermostat_bathroom
  	remove_column :presets, :thermostat_garage
  end
end
