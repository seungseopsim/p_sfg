class Cubedb::VShPpcUse < Cubedb::CubeDbBase
		
	def self.selectall(_day)
		if _day.present?
			day = _day
		end

		query = "SELECT * FROM v_sh_ppc_use WHERE BSN_DT = '%{day}'; " % [ day: day ]
		
		return execute_all(query)
	end
	
end