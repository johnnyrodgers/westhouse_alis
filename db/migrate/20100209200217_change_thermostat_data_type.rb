class ChangeThermostatDataType < ActiveRecord::Migration
  def self.up
  	execute "ALTER TABLE presets MODIFY thermostat_main FLOAT NOT NULL DEFAULT 0.0"
  	execute "ALTER TABLE presets MODIFY thermostat_loft FLOAT NOT NULL DEFAULT 0.0"
  	execute "ALTER TABLE presets MODIFY thermostat_bathroom FLOAT NOT NULL DEFAULT 0.0"
  	execute "ALTER TABLE presets MODIFY thermostat_garage FLOAT NOT NULL DEFAULT 0.0"
  end

  def self.down
  	execute "ALTER TABLE presets MODIFY thermostat_main INT NOT NULL DEFAULT 0"
  	execute "ALTER TABLE presets MODIFY thermostat_loft INT NOT NULL DEFAULT 0"
  	execute "ALTER TABLE presets MODIFY thermostat_bathroom INT NOT NULL DEFAULT 0"
  	execute "ALTER TABLE presets MODIFY thermostat_garage INT NOT NULL DEFAULT 0"
  end
end
