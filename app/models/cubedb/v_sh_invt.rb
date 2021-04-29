class Cubedb::VShInvt < Cubedb::CubeDbBase
	
	def self.selectall
		query = "SELECT * FROM v_sh_invt WHERE SO_DATE = '%{day}'; " % [ day: Date.yesterday]
	
		return execute_all(query)
	end
	
end