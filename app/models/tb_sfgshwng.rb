class TbSfgshwng < ApplicationRecord
	
	@@ref = "주간".freeze
	
	def self.selectlastday 
		query = "SELECT MAX(shwng_begin) as shwng_begin FROM tb_sfgshwng WHERE shwng_ref = '#{@@ref}';"

		return connection.select_one(query)
	end
	
	def self.getshopinfo(_shopids)
					
		shoplist = shopidsTolist(_shopids)
		if shoplist.blank?
			return nil
		end 
		shopidlist = _shopids.split(",")
		
		result = connection.select_all("SELECT ANY_VALUE(shop_id) AS id, ANY_VALUE(shop_nm) AS nm, ANY_VALUE(shwng_sales) AS sales, ANY_VALUE(shwng_salesprevy) AS salesprevy, ANY_VALUE(shwng_salesprevm) AS salesprevm, ANY_VALUE(shwng_salesrateprevy) AS salesrateprevy, ANY_VALUE(shwng_salesrateprevm) AS salesrateprevm, ANY_VALUE(shwng_prate) AS prate, ANY_VALUE(shwng_lrate) AS lrate, (ANY_VALUE(shwng_prate)+ANY_VALUE(shwng_lrate)) AS pltotal FROM (SELECT shop_id, shop_nm, shwng_begin, shwng_sales, shwng_salesprevy, shwng_salesprevm, shwng_salesrateprevy, shwng_salesrateprevm, shwng_prate, shwng_lrate FROM tb_sfgshwng WHERE (%{shoplist}) AND shwng_ref = '%{ref}' ORDER BY shwng_begin DESC limit %{limit}) AS RESULT GROUP BY RESULT.shop_id;" % [shoplist: shoplist, limit: shopidlist.length, ref: @@ref])
			
		result.each do |key| 
			key['sales'] = (key['sales'] / 10000).round(1)
			key['salesprevy'] = (key['salesprevy'] / 10000).round(1)
			key['salesprevm'] = (key['salesprevm'] / 10000).round(1)
		end
		
		return result
	end
	
	def self.getshopinfoTotal(_shopids)
		
		shoplist = shopidsTolist(_shopids)
		if shoplist.blank?
			return nil
		end 
		
		shopidlist = _shopids.split(",")
		
		query = "SELECT sum(shwng_sales) AS sales, sum(shwng_salesprevy) AS salesprevy, sum(shwng_salesprevm) AS salesprevm, sum(shwng_prate * shwng_sales) AS prate, sum(shwng_lrate * shwng_sales) AS lrate FROM ( SELECT ANY_VALUE(shop_id), ANY_VALUE(shop_nm), ANY_VALUE(shwng_sales) AS shwng_sales, ANY_VALUE(shwng_salesprevy) AS shwng_salesprevy, ANY_VALUE(shwng_salesprevm) AS shwng_salesprevm, ANY_VALUE(shwng_salesrateprevy),  ANY_VALUE(shwng_salesrateprevm), ANY_VALUE(shwng_prate) AS shwng_prate, ANY_VALUE(shwng_lrate) AS shwng_lrate FROM (SELECT shop_id, shop_nm, shwng_begin, shwng_sales, shwng_salesprevy, shwng_salesprevm, shwng_salesrateprevy, shwng_salesrateprevm, shwng_prate, shwng_lrate
 FROM tb_sfgshwng WHERE (%{shoplist}) and shwng_ref = '%{ref}' ORDER BY shwng_begin DESC limit %{limit}) AS TEMP ) AS RESULT;" % [shoplist: shoplist, ref: @@ref, limit: shopidlist.length ]
		
		queryresult = connection.select_one(query)
		
		result = nil
		if(queryresult.present?)
			result = Hash.new
			result[:sales] = queryresult['sales']
			result[:salesprevy] = queryresult['salesprevy']
			result[:salesprevm] = queryresult['salesprevm']
			result[:salesprevyavg] = (((result[:sales] - result[:salesprevy]) / result[:salesprevy].to_f) * 100).round(1)
			result[:salesprevmavg] = (((result[:sales] - result[:salesprevm]) / result[:salesprevm].to_f) * 100).round(1)
			result[:prateavg] = (queryresult['prate'] / result[:sales]).round(1)
			result[:lrateavg] = (queryresult['lrate'] / result[:sales]).round(1)
			result[:plratetotal] = result[:prateavg] + result[:lrateavg]
			
			result[:sales] = (result[:sales] / 10000).round(1)
			result[:salesprevy] = (result[:salesprevy] / 10000).round(1)
			result[:salesprevm] = (result[:salesprevm] / 10000).round(1)
		end
		
		return result
	end
	
	private
	
	def self.shopidsTolist(_ids)
		if _ids.blank?
			return nil
		end 
		
		shopidlist = _ids.split(",")
		shoplist = nil
		
		if shopidlist.length <= 0
			return nil	
		end
				
		if( shopidlist.length > 0 )
			shoplist = "shop_id = '#{shopidlist[0]}'"
		end
		
		for index in 1...shopidlist.length do 
			shoplist += " OR shop_id = '#{shopidlist[index]}'"
		end
		
		return shoplist
	end
	
	def self.getcompanylist_top
		
		#query = "SELECT shop_nm, shwng_salesrateprevm, round(shwng_sales/10000, 0) as '매출' 
		#		from tb_sfgshwng 
		#		WHERE shop_nm not like '%블루%' 
		#			AND shop_nm not like '%자작%'  
		#			AND shop_nm not like '%고삼%'  
		#		order by shwng_begin desc, shwng_salesrateprevm DESC
		#		limit 5;"	
		
		
		
		query = "SELECT PREVS.shop_nm, 
      TRUNCATE(((CURRS.m_cur - PREVS.m_pre)/PREVS.m_pre)*100, 1) as shwng_salesrateprevm, 
      TRUNCATE(m_cur/10000, 1) as '매출'
from (SELECT shop_nm, avg(sb_real_amt) as m_pre
      from tb_sales_daily   
      WHERE  left(DATE_SUB(  curdate() - INTERVAL 1 day,  INTERVAL 1 month  ) ,7) = left(bsn_dt,7)
      group by shop_nm) as PREVS
join (SELECT shop_nm, avg(sb_real_amt) as m_cur
      from tb_sales_daily    
      WHERE  left(DATE_SUB(  curdate() - INTERVAL 1 day,  INTERVAL 0 month  ) ,7) = left(bsn_dt,7)
      group by shop_nm) as CURRS
on PREVS.shop_nm = CURRS.shop_nm
WHERE PREVS.shop_nm not like '%블루%' AND PREVS.shop_nm not like '%자작%' AND PREVS.shop_nm not like '%고삼%'
group by shop_nm
order by shwng_salesrateprevm desc LIMIT 5;"
		
		
		
		return connection.select_all(query)
	end
	
	def self.getcompanylist_bottom
		#query = "SELECT shop_nm, shwng_salesrateprevm, round(shwng_sales/10000, 0) as '매출' 
		#		from tb_sfgshwng 
		#		WHERE shop_nm not like '%블루%' 
		#			AND shop_nm not like '%자작%'  
		#			AND shop_nm not like '%고삼%'  
		#		order by shwng_begin desc, shwng_salesrateprevm ASC
		#		limit 5;"	
		
		query = "SELECT PREVS.shop_nm, 
      TRUNCATE(((CURRS.m_cur - PREVS.m_pre)/PREVS.m_pre)*100, 1) as ratio, 
      TRUNCATE(m_cur/10000, 1) as sales
from (SELECT shop_nm, avg(sb_real_amt) as m_pre
      from tb_sales_daily   
      WHERE  left(DATE_SUB(  curdate() - INTERVAL 1 day,  INTERVAL 1 month  ) ,7) = left(bsn_dt,7)
      group by shop_nm) as PREVS
join (SELECT shop_nm, avg(sb_real_amt) as m_cur
      from tb_sales_daily    
      WHERE  left(DATE_SUB(  curdate() - INTERVAL 1 day,  INTERVAL 0 month  ) ,7) = left(bsn_dt,7)
      group by shop_nm) as CURRS
on PREVS.shop_nm = CURRS.shop_nm
WHERE PREVS.shop_nm not like '%블루%' AND PREVS.shop_nm not like '%자작%' AND PREVS.shop_nm not like '%고삼%'
group by shop_nm
order by ratio asc LIMIT 5;"
		
		return connection.select_all(query)
	end
	
	def self.getstandarddate
		query = "SELECT shwng_ref, shwng_begin from tb_sfgshwng order by shwng_begin desc limit 1;"	
		return connection.select_one(query)
	end
	
	
end