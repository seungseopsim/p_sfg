class Cubedb::VShSalesCurrent < Cubedb::CubeDbBase

	# 매출 합계
	def self.sfg_sum
		return execute_one("SELECT SUM(b_real_amt) AS total FROM v_sh_sales_current;")
	end
	
	#자작 제외
	def self.sfg_sum_without_j
		return execute_one("SELECT SUM(b_real_amt) AS total FROM v_sh_sales_current WHERE shop_nm NOT LIKE '%자작%';")
	end
	
	# 부서별 합계
	def self.business_sum
		query = "SELECT s_id, SUM(b_real_amt) as total FROM v_sh_sales_current GROUP BY s_id ORDER BY s_id ASC;"
		return execute_all(query)
	end
	
	def self.business_sum_with_shoplist(_shoplist)
		if(_shoplist.nil?)
			return
		end
				
		options = nil
		_shoplist.each do |info|
			shops = info['shop_id'].split(',')
			shops.each do |shop|
				if options.blank?
					options = "shop_id = '#{shop}' "
				else
					options += "OR shop_id = '#{shop}' "
				end
			end
		end
		
		query = "SELECT s_id, SUM(b_real_amt) as total FROM v_sh_sales_current WHERE %{option} GROUP BY s_id, shop_id ORDER BY s_id ASC;" % [option: options]

		return execute_all(query)
	end
	
	# 가게별 합계
	def self.shop_sum(_type, _shopid)
		options = nil
		shopid = _shopid
		if _type == 1
			if shopid == ApplicationRecord.SH_JJ_ID
				shopid = ApplicationRecord.CUBE_JJ_ID
			end
			options = "s_id = '#{shopid}'"
		else
			options = "shop_id = '#{shopid}'"
		end
				
		query = "SELECT shop_id, shop_nm, s_id, shop_sort, sum(b_real_amt) AS total FROM v_sh_sales_current WHERE %{options} GROUP BY shop_id, shop_nm, s_id, shop_sort ORDER BY shop_sort ASC;" % [options: options]

		return execute_all(query)
	end
	
	def self.sfg_sum_time
	
		query = "SELECT sum(b_real_amt) AS amt, DATEPART(hour, b_crg_dt) AS hour FROM v_sh_sales_current WHERE shop_nm NOT LIKE '%%자작%%' GROUP BY DATEPART(hour, b_crg_dt);" % [start: 0, end: 10]
		queryresult = execute_all(query)
		
		result = Hash.new
		result[0] = hashsum(queryresult, 'amt', 0, 10)
		result[10] = hashsum(queryresult, 'amt', 10, 11)
		result[11] = hashsum(queryresult, 'amt', 11, 12)
		result[12] = hashsum(queryresult, 'amt', 12, 13)
		result[13] = hashsum(queryresult, 'amt', 13, 14)
		result[14] = hashsum(queryresult, 'amt', 14, 15)
		result[15] = hashsum(queryresult, 'amt', 15, 16)
		result[16] = hashsum(queryresult, 'amt', 16, 17)
		result[17] = hashsum(queryresult, 'amt', 17, 18)
		result[18] = hashsum(queryresult, 'amt', 18, 19)
		result[19] = hashsum(queryresult, 'amt', 19, 20)
		result[20] = hashsum(queryresult, 'amt', 20, 21)
		result[21] = hashsum(queryresult, 'amt', 21, 22)
		result[22] = hashsum(queryresult, 'amt', 22, 0)
		return result
	end
	
	private
	def self.hashsum(_queryresult, _key, _start, _end)
		if _queryresult.blank?
			return 0
		end
		
		if( _end < _start)
			temp = _queryresult.select{ |key| key['hour'] >= _start }
		else
			temp = _queryresult.select{ |key| key['hour'] >= _start && key['hour'] < _end }
		end
	
		#return temp.sum{ |key| key[_key] }
		return temp.sum{ |key| (key[_key].to_i * 0.0001).to_i }
	end
	
end
