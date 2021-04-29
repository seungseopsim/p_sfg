class Cubedb::VShSoDetail < Cubedb::CubeDbBase
	
	def self.selectall
		query = "SELECT * FROM v_sh_so_detail WHERE SO_DT = '%{day}'; " % [ day: Date.yesterday]
		
		return execute_all(query)
	end
end