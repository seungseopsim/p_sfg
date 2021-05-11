class Cubedb::VShInvt < Cubedb::CubeDbBase
	
	def self.selectall(_day)
		day = Date.yesterday
		if( _day.present?)
			day = _day
		end
		query = "SELECT * FROM v_sh_invt WHERE SO_DATE = '%{day}'; " % [day: day]
	
		return execute_all(query)
	end
	
end