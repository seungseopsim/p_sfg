class Cubedb::VShCosDaliy < Cubedb::CubeDbBase
	

	def self.selectall(_day)
		if _day.present?
			day = _day
		end
=begin
		query = "SELECT count(H_ID) AS CNT FROM v_sh_cos_daily WHERE BSN_DT = '%{day}'; " % [ day: day ]
		queryresult = execute_one(query)
		
		datacnt = queryresult['CNT']

		result = Array.new
		1.step(datacnt, 10) { |x| 
	query = "SELECT * FROM ( SELECT ROW_NUMBER() OVER(ORDER BY BSN_DT) AS rownum, * FROM v_sh_cos_daily WHERE BSN_DT = '%{day}') A WHERE rownum >= %{start} AND rownum < %{end};" % [ day: day, start: x, end: x + 10 ]
			
			queryresult = execute_all(query)
			result += queryresult
		}
		
		return result
=end
		query = "SELECT * FROM v_sh_cos_daily WHERE BSN_DT = '%{day}'; " % [ day: day ]
		return execute_all(query)
	end

end