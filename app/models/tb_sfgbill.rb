#빌단가
class TbSfgbill < ApplicationRecord

	def self.selectlastday
		query = "SELECT MAX(sfgbill_dt) as sfgbill_dt FROM tb_sfgbill"
		return connection.select_one(query)
	end
	

	# 주중 주말
	def self.search_week_price(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_week_price_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt; " % [month: _month, dayformat: "%Y%m", cat: "종합"]
		
		queryresult = connection.select_all(query)
		
		return calavgweek_price(queryresult, 'cat_short')
	end
	
	#점심, 저녁
	def self.search_lunch_price(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_lunch_price_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt; " % [month: _month, dayformat: "%Y%m", cat: "종합"]
		queryresult = connection.select_all(query)
				
		return calavglunch_price(queryresult, 'cat_short')
	end
	
	
	#육류/식사
	def self.search_meal_price(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_meal_price_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 OR PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		queryresult = connection.select_all(query)
				
		return calavgmeal_price(queryresult, 'cat_short')
	end
	
	
	# 주중 주말 매장 별
	def self.search_week_price_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	def self.search_week_price_shop_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		return connection.select_all(query)
	end
	
	
	#전월 증감
	def self.search_week_price_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
				
		return calavgweek_price(queryresult, 'shop_nm')
	end
	
	def self.search_week_price_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cawt) AS cawt, AVG(sfgbill_caht) AS caht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1  AND shop_id = '%{id}' GROUP BY shop_nm ORDER BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
				
		return calavgweek_price(queryresult, 'shop_nm')
	end
	
	#점심, 저녁 매장 별
	def self.search_lunch_price_shop_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid ]
		
		return connection.select_all(query)
	end
	
	def self.search_lunch_price_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_lunch_price_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
		
		return calavglunch_price(queryresult, 'shop_nm')
	end
	
		def self.search_lunch_price_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cael) AS cael, AVG(sfgbill_caed) AS caed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
		
		return calavglunch_price(queryresult, 'shop_nm')
	end
	
	#육류/식사 매장 별
	def self.search_meal_price_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	def self.search_meal_price_shop_with_shopid(_month, _shop_id)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shop_id]
		
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_meal_price_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
				
		return calavgmeal_price(queryresult, 'shop_nm')
	end
	
	def self.search_meal_price_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_caet) AS caet, AVG(sfgbill_cmet) AS cmet, AVG(sfgbill_cfet) AS cfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
				
		return calavgmeal_price(queryresult, 'shop_nm')
	end
	
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	#빌수
		# 주중 주말
	def self.search_week_piece(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_week_piece_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt; " % [month: _month, dayformat: "%Y%m", cat: "종합"]
		queryresult = connection.select_all(query)
				
		return calavgweek_piece(queryresult, 'cat_short')
	end
	
	#점심, 저녁
	def self.search_lunch_piece(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_lunch_piece_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt; " % [month: _month, dayformat: "%Y%m", cat: "종합"]
		queryresult = connection.select_all(query)
				
		return calavglunch_piece(queryresult, 'cat_short')
	end
	
	
	#육류/식사
	def self.search_meal_piece(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_meal_piece_previousmonth_compairson(_month)
		query = "SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt UNION SELECT cat_short, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 OR PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat = '%{cat}' GROUP BY cat_short, sfgbill_dt;" % [month: _month, dayformat: "%Y%m", cat: "종합"]
		queryresult = connection.select_all(query)
		
		return calavgmeal_piece(queryresult, 'cat_short')
	end
	
	
	# 주중 주말 매장 별
	def self.search_week_piece_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	def self.search_week_piece_shop_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_week_piece_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
		
		return calavgweek_piece(queryresult, 'shop_nm')
	end
	
		def self.search_week_piece_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bawt) AS bawt, AVG(sfgbill_baht) AS baht FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1  AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
		
		return calavgweek_piece(queryresult, 'shop_nm')
	end
	
	#점심, 저녁 매장 별
	def self.search_lunch_piece_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	def self.search_lunch_piece_shop_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		return connection.select_all(query)
	end
	
	#전월 증감
	def self.search_lunch_piece_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
				
		return calavglunch_piece(queryresult, 'shop_nm')
	end
	
	def self.search_lunch_piece_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bael) AS bael, AVG(sfgbill_baed) AS baed FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
				
		return calavglunch_piece(queryresult, 'shop_nm')
	end
	
	#육류/식사 매장 별
	def self.search_meal_piece_shop(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		return connection.select_all(query)
	end
	
	def self.search_meal_piece_shop_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		return connection.select_all(query)
	end
	#전월 증감
	def self.search_meal_piece_shop_previousmonth_compairson(_month, _cat_short)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND cat_short LIKE '%{cat_short}' AND cat NOT LIKE '%{cat}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", cat_short: "%#{_cat_short}%", cat: "%종합%"]
		
		queryresult = connection.select_all(query)
				
		return calavgmeal_piece(queryresult, 'shop_nm')
	end
	
	def self.search_meal_piece_shop_previousmonth_compairson_with_shopid(_month, _shopid)
		query = "SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = 0  AND shop_id = '%{id}' GROUP BY shop_nm UNION SELECT shop_nm, AVG(sfgbill_baet) AS baet, AVG(sfgbill_bmet) AS bmet, AVG(sfgbill_bfet) AS bfet FROM tb_sfgbill WHERE PERIOD_DIFF(date_format(sfgbill_dt, '%{dayformat}'), '%{month}') = -1 AND shop_id = '%{id}' GROUP BY shop_nm;" % [month: _month, dayformat: "%Y%m", id: _shopid]
		
		queryresult = connection.select_all(query)
				
		return calavgmeal_piece(queryresult, 'shop_nm')
	end
	
	private
	
	def self.calavgweek_price(_queryresult, _key)
		if(_queryresult.blank?)
			return _queryresult
		end
		
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }
		default = "-"
		
		grouplist.each do |key, value|
			if value.length > 1
				caet1 = value[0]['caet']
				caet2 = value[1]['caet']
				avg = default
				
				cawt1 = value[0]['cawt']
				cawt2 = value[1]['cawt']
				weekday = default
				
				caht1 = value[0]['caht'] 
				caht2 = value[1]['caht'] 
				weekend = default
				
				if caet1.blank? || caet2.blank? 
					
				else
					if caet2 > 0.0
						avg = ((caet1 - caet2)/caet2 * 100).round(1)	
					end
				end
				
				if cawt1.blank? || cawt2.blank? 
	
				else
					if cawt2 > 0.0
						weekday = ((cawt1 - cawt2)/cawt2 * 100).round(1)
					end
				end
				
				if caht1.blank? || caht2.blank? 
				
				else
					if caht2 > 0.0
						weekend = ((caht1 - caht2)/caht2 * 100).round(1)
					end
				end
				
				result[key] = { caet: avg, cawt: weekday, caht: weekend}
			else
				result[key] = { caet: default, cawt: default, caht: default }
			end
		end
		
		return result
	end
	
		
	def self.calavglunch_price(_queryresult, _key)		
		if(_queryresult.blank?)
			return _queryresult
		end
		
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }
		
		grouplist.each do |key, value|
			if value.length > 1
				if value[0]['caet'].blank? || value[1]['caet'].blank? 
					avg = 0.0
				else
					avg = ((value[0]['caet'] - value[1]['caet'])/value[1]['caet'] * 100).round(1)	
				end
				
				if value[0]['cael'].blank? || value[1]['cael'].blank? 
					weekday = 0.0
				else
					weekday = ((value[0]['cael'] - value[1]['cael'])/value[1]['cael'] * 100).round(1)
				end
				
				if value[0]['caed'].blank? || value[1]['caed'].blank? 
					weekend = 0.0
				else
					weekend = ((value[0]['caed'] - value[1]['caed'])/value[1]['caed'] * 100).round(1)
				end
				
				result[key] = { caet: avg, cael: weekday, caed: weekend}
			else
				result[key] = { caet: "-", cael: "-", caed: "-" }
			end
		end
		
		return result
	end

	def self.calavgmeal_price(_queryresult, _key)		
		if(_queryresult.blank?)
			return _queryresult
		end
		
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }
		
		grouplist.each do |key, value|
			if value.length > 1
				caet1 = value[0]['caet']
				caet2 =  value[1]['caet']
				
				cmet1 = value[0]['cmet']
				cmet2 = value[1]['cmet']
				
				cfet1 = value[0]['cfet']
				cfet2 = value[1]['cfet']
				
				if caet1.blank? || caet2.blank? 
					avg = "-"
				else
					if caet2 > 0.0 
						avg = ((caet1 - caet2)/caet2 * 100).round(1)	
					else
						avg = "-"
					end
				end
				
				if cmet1.blank? || cmet2.blank? 
					weekday = "-"
				else
					if cmet2 > 0.0
						weekday = ((cmet1 - cmet2)/cmet2 * 100).round(1)
					else
						weekday = "-"
					end
				end
				
				if cfet1.blank? || cfet2.blank? 
					weekend = "-"
				else
					if cfet2 > 0.0
						weekend = ((cfet1 - cfet2)/cfet2 * 100).round(1)
					else
						weekend = "-"
					end
				end
				
				result[key] = { caet: avg, cmet: weekday, cfet: weekend}
			else
				result[key] = { caet: "-", cmet: "-", cfet: "-" }
			end
		end
		
		return result
	end
	
	def self.calavgweek_piece(_queryresult, _key)
		if(_queryresult.blank?)
			return _queryresult
		end
	
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }

		grouplist.each do |key, value|
			if value.length > 1
				if value[0]['baet'].blank? || value[1]['baet'].blank? 
					avg = 0.0
				else
					avg = ((value[0]['baet'] - value[1]['baet'])/value[1]['baet'] * 100).round(1)	
				end
				
				if value[0]['bawt'].blank? || value[1]['bawt'].blank? 
					weekday = 0.0
				else
					weekday = ((value[0]['bawt'] - value[1]['bawt'])/value[1]['bawt'] * 100).round(1)
				end
				
				if value[0]['baht'].blank? || value[1]['baht'].blank? 
					weekend = 0.0
				else
					weekend = ((value[0]['baht'] - value[1]['baht'])/value[1]['baht'] * 100).round(1)
				end
				
				result[key] = { baet: avg, bawt: weekday, baht: weekend}
			else
				result[key] = { baet: "-", bawt: "-", baht: "-" }
			end
		end
		
		return result
	end
	
	def self.calavglunch_piece(_queryresult, _key)		
		if(_queryresult.blank?)
			return _queryresult
		end
		
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }
		
		grouplist.each do |key, value|
			if value.length > 1
				if value[0]['baet'].blank? || value[1]['baet'].blank? 
					avg = 0.0
				else
					avg = ((value[0]['baet'] - value[1]['baet'])/value[1]['baet'] * 100).round(1)	
				end
				
				if value[0]['bael'].blank? || value[1]['bael'].blank? 
					weekday = 0.0
				else
					weekday = ((value[0]['bael'] - value[1]['bael'])/value[1]['bael'] * 100).round(1)
				end
				
				if value[0]['baed'].blank? || value[1]['baed'].blank? 
					weekend = 0.0
				else
					weekend = ((value[0]['baed'] - value[1]['baed'])/value[1]['baed'] * 100).round(1)
				end
				
				result[key] = { baet: avg, bael: weekday, baed: weekend}
			else
				result[key] = { baet: "-", bael: "-", baed: "-" }
			end
		end
		
		return result
	end

	def self.calavgmeal_piece(_queryresult, _key)		
		if(_queryresult.blank?)
			return _queryresult
		end
		
		result = Hash.new
		grouplist =	_queryresult.lazy.group_by{ |key| key[_key] }
		
		grouplist.each do |key, value|
			if value.length > 1
				if value[0]['baet'].blank? || value[1]['baet'].blank? 
					avg = 0.0
				else
					avg = ((value[0]['baet'] - value[1]['baet'])/value[1]['baet'] * 100).round(1)	
				end
				
				if value[0]['bmet'].blank? || value[1]['bmet'].blank? 
					weekday = 0.0
				else
					weekday = ((value[0]['bmet'] - value[1]['bmet'])/value[1]['bmet'] * 100).round(1)
				end
				
				if value[0]['bfet'].blank? || value[1]['bfet'].blank? 
					weekend = 0.0
				else
					weekend = ((value[0]['bfet'] - value[1]['bfet'])/value[1]['bfet'] * 100).round(1)
				end
				
				result[key] = { baet: avg, bmet: weekday, bfet: weekend}
			else
				result[key] = { baet: "-", bmet: "-", bfet: "-" }
			end
		end
		
		return result
	end
end