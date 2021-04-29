class Cubedb::VShIdxInvt < Cubedb::CubeDbBase
	
	def self.selectall
		query = 'SELECT * FROM v_sh_idx_invt;'
		
		return execute_all(query)
	end
	
end