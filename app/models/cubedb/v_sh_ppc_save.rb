class Cubedb::VShPpcSave < Cubedb::CubeDbBase
	
	
	def self.selectall(_day)
		day = Date.yesterday
		if _day.present?
			day = _day
		end
		query = "SELECT * FROM v_sh_ppc_save WHERE BSN_DT = '%{day}'; " % [day: day]
		
		return execute_all(query)
	end
	
end