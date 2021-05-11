class Cubedb::VShSoDetail < Cubedb::CubeDbBase
	
	def self.selectall(_day)
		day = Date.yesterday
		if _day.present?
			day = _day
		end
		
		query = "SELECT * FROM v_sh_so_detail WHERE SO_DT = '%{day}'; " % [day: day]
		
		return execute_all(query)
	end
end