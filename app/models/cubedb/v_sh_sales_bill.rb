class Cubedb::VShSalesBill < Cubedb::CubeDbBase
			
	def self.selectall
		query = "SELECT * FROM v_sh_sales_bill WHERE BSN_DT = '%{day}'; " % [ day: Date.yesterday]
		
		return execute_all(query)
	end
	
end