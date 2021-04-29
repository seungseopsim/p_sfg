class TbSfgpl < ApplicationRecord
	
	$basequery = "SELECT sfgpl_dt, shoptotal.s_nm_short, shoptotal.b_id".freeze
	$baseselect = "sum(s1000) AS '매출', sum(s2000) AS '매출원가', sum(s2200) AS '인건비', sum(s2201) AS '급여', sum(s2202)+sum(s2203) AS '기타', sum(s2204) AS '주차대행료', sum(s2100) AS '식자재비', sum(s2101) AS '육류', sum(s2102) AS '어패류', sum(s2103) AS '기타식자재', sum(s2104) AS '주류/음료', sum(s1000)-sum(s2000) AS '매출총이익', sum(s2300) AS '판관비', sum(s2301)+sum(s2302)+sum(s2303)+sum(s2304) AS '수광비', sum(s2301) AS '가스', sum(s2302) AS '수도', sum(s2303)+sum(s2304) AS '전기/난방', sum(s2306) AS '임차료', sum(s2300)-'수광비'-'임차료' AS '기타판관비', sum(s2400) AS '부가세', '매출총이익'-'판관비'-'부가세' AS '영업이익', sum(s4000) AS '영업외손익', sum(s4100) AS '영업외수익', sum(s4200) AS '영업외손실', sum(s6000) AS '세전이익', sum(s7000) AS '법인세', sum(s8000) AS '당기순이익', sum(s9000) AS '공시순이익' FROM tb_sfgpl Left JOIN idx_shoptotal AS shoptotal ON shoptotal.shop_id = tb_sfgpl.shop_id WHERE  PERIOD_DIFF(date_format(sfgpl_dt, '%Y%m'), ".freeze
	
	$baseoption = ") = 0 AND s_nm_short IS NOT NULL AND s_nm_short NOT LIKE '%{short}' AND b_id IS NOT NULL AND shop_id IS NOT NULL".freeze
	$basegroupby = "GROUP BY shoptotal.s_nm_short, shoptotal.b_id, sfgpl_dt".freeze
	
	
	def self.search_business(_day, _sort, _div)
		day = nil		
		if(_day.blank?)
			queryresult = connection.select_one("SELECT MAX(sfgbill_dt) AS DT FROM tb_sfgbill")
			day = queryresult['DT'].delete("-")
		else
			day = _day.delete("-")
		end
		
		query = "%{base}, shoptotal.s_nm_div, %{select} '%{dt}') = 0 AND s_nm_short IS NOT NULL AND s_nm_short NOT LIKE '%{short}' AND b_id IS NOT NULL AND tb_sfgpl.shop_id IS NOT NULL AND s_nm_div LIKE '%%%{s_nm_div}%%' %{groupby}, shoptotal.s_nm_div ;" % [base: $basequery, select: $baseselect, dt: day, short: "%#{_sort}%", option: $baseoption, s_nm_div: _div, groupby: $basegroupby]
		
		queryresult = connection.select_one(query)
		
		queryresult['기타판관비'] = queryresult['기타판관비'] - queryresult['수광비'] - queryresult['임차료']
		queryresult['영업이익'] = queryresult['매출총이익'] - queryresult['판관비'] - queryresult['부가세']
		
		return queryresult
	end
	
	def self.search_shop(_day, _sort, _shopid)
		day = nil		
		if(_day.blank?)
			queryresult = connection.select_one("SELECT MAX(sfgbill_dt) AS DT FROM tb_sfgbill")
			day = queryresult['DT'].delete("-")
		else	
			day = _day.delete("-")
		end
		
		query = "%{base}, tb_sfgpl.shop_id, %{select} '%{dt}') = 0 AND s_nm_short IS NOT NULL AND s_nm_short NOT LIKE '%{short}' AND b_id IS NOT NULL AND tb_sfgpl.shop_id IS NOT NULL AND tb_sfgpl.shop_id LIKE '%%%{shopid}%%' %{groupby}, tb_sfgpl.shop_id ;" % [base: $basequery, select: $baseselect, dt: day, short: "%#{_sort}%", option: $baseoption, shopid: _shopid, groupby: $basegroupby]
		
		
		queryresult = connection.select_one(query)
		
		queryresult['기타판관비'] = queryresult['기타판관비'] - queryresult['수광비'] - queryresult['임차료']
		queryresult['영업이익'] = queryresult['매출총이익'] - queryresult['판관비'] - queryresult['부가세']
		
		return queryresult

	end

end