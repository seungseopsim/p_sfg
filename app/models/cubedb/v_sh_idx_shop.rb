class Cubedb::VShIdxShop < Cubedb::CubeDbBase
	
	def self.selectall
		return execute_all('SELECT * FROM v_sh_idx_shop; ')	
	end
	
end