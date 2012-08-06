class AddNewLights < ActiveRecord::Migration
  def self.up
  	add_column :presets, :kitchen, :int, :default => 0
  	add_column :presets, :hallway, :int, :default => 0
  	add_column :presets, :bathroom, :int, :default => 0
  	add_column :presets, :bathroom_mirror, :int, :default => 0
  	add_column :presets, :bedside_lamps, :int, :default => 0
  end

  def self.down
  	remove_column :presets, :kitchen
  	remove_column :presets, :hallway
  	remove_column :presets, :bathroom
  	remove_column :presets, :bathroom_mirror
  	remove_column :presets, :bedside_lamps
  end
end
