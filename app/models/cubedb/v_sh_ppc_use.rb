class Cubedb::VShPpcUse < Cubedb::CubeDbBase
		
	def self.selectall
		query = "SELECT * FROM v_sh_ppc_use WHERE BSN_DT = '%{day}'; " % [ day: Date.yesterday]
		
		return execute_all(query)
	end
	
end