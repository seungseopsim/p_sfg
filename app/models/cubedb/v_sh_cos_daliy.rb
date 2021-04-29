class Cubedb::VShCosDaliy < Cubedb::CubeDbBase
	

	def self.selectall	
		query = "SELECT * FROM v_sh_cos_daily WHERE BSN_DT = '%{day}'; " % [ day: Date.yesterday]
		
		#query = "SELECT * FROM v_sh_cos_daily WHERE BSN_DT = '2015-08-01'; "
		#query = "SELECT top 10 *, CONVERT(varchar(6), BSN_DT, 112 ) AS CST FROM v_sh_cos_daily order by BSN_DT;"
		return execute_all(query)	
	end

end