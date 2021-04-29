class Cubedb::VShSalesDaily < Cubedb::CubeDbBase

	def self.selectall
		query = "SELECT * FROM v_sh_sales_daily WHERE BSN_DT = '%{day}'; " % [ day: Date.yesterday]
		
		return execute_all(query)	

	end
	
end
