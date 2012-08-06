class Control < ActiveRecord::Base
	set_table_name "lightstatus"
	
	establish_connection "datalogs"
end
