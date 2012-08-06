class CreatePresets < ActiveRecord::Migration
  def self.up
    create_table :presets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :presets
  end
end
