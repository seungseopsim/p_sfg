## 사용 안함 ##
## 실시간 연동함 ##
class TbSalesCurrent < ApplicationRecord
		
	# 매출 합계
	def self.sfg_sum
		return connection.select_one("SELECT SUM(b_real_amt) AS total FROM tb_sales_current;");
	end
	
	# 부서별 합계
	def self.business_sum
		query = "SELECT idx_shoptotal.s_nm_short, idx_shoptotal.s_id, sum(tb_sales_current.b_real_amt) AS total FROM tb_sales_current Left JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_current.shop_id WHERE s_nm_short IS NOT NULL Group BY idx_shoptotal.s_nm_short, idx_shoptotal.s_id order BY idx_shoptotal.s_id asc; "

		return connection.select_all(query)
	end

	# 가게별 합계
	def self.shop_sum(_shopid)
		query = "SELECT shop_id, shop_nm, s_id, shop_sort, sum(b_real_amt) AS total FROM tb_sales_current WHERE s_id = '%{id}' GROUP BY shop_id, shop_nm, s_id, shop_sort ORDER BY shop_sort ASC;" % [id: _shopid]

		return connection.select_all(query)
	end
	
end