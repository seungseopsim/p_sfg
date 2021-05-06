class Cubedb::VShCosDaliy < Cubedb::CubeDbBase
	

	def self.selectall(_day)
		day = Date.yesterday
		if _day.present?
			day = _day
		end
	
		query = "SELECT * FROM v_sh_cos_daily WHERE BSN_DT = '%{day}'; " % [ day: day ]
		
		#query = "SELECT * FROM v_sh_cos_daily WHERE BSN_DT = '2015-08-01'; "
		#query = "SELECT top 10 *, CONVERT(varchar(6), BSN_DT, 112 ) AS CST FROM v_sh_cos_daily order by BSN_DT;"
		return execute_all(query)	
	end

end