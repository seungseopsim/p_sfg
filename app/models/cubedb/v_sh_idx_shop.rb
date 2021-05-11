class Cubedb::VShIdxShop < Cubedb::CubeDbBase
	
	def self.selectall
		query = 'SELECT * FROM v_sh_idx_shop;'
		return execute_all(query)	
	end
	
end