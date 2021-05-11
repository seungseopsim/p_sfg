class Cubedb::VShSalesDetail < Cubedb::CubeDbBase
	
	# select all
	def self.selectall(_day)
		if _day.present?
			day = _day
		end

		query = "SELECT * FROM v_sh_sales_detail WHERE BSN_DT = '%{day}'; " % [ day: day ]
		return execute_all(query)
	end
	
	# count
	def self.select_count(_day)
		if _day.present?
			day = _day
		end

		query = "SELECT COUNT(h_id) AS CNT FROM v_sh_sales_detail WHERE BSN_DT = '%{day}'; " % [ day: day ]
		result = execute_one(query)
		return result['CNT']
	end
	
	# select range
	def self.select_range(_day, _start, _last)
		if _day.present?
			day = _day
		end

		query = "SELECT rownum, * FROM (SELECT ROW_NUMBER() OVER(ORDER BY BSN_DT) AS rownum, * FROM v_sh_sales_detail WHERE BSN_DT = '%{day}') ORIGINE WHERE rownum >= %{start} AND rownum < %{last}; " % [ day: day, start: _start, last: _last]
		return execute_all(query)
	end
	
end