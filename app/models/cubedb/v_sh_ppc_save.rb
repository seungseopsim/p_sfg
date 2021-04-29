class Cubedb::VShPpcSave < Cubedb::CubeDbBase
	
	
	def self.selectall
		query = "SELECT * FROM v_sh_ppc_save WHERE BSN_DT = '%{day}'; " % [ day: Date.yesterday]
		
		return execute_all(query)
	end
	
end