class IdxShoptotal < ApplicationRecord
	
		
	def self.selectinfo_with_shoplist(_shoplist)
		
		shops = _shoplist.split(',')
		options = nil
		shops.each do |shop|
			if options.blank?
				options = "A.shop_id = '#{shop}' "
			else
				options += "OR A.shop_id = '#{shop}' "
			end
		end
	
		query = "SELECT A.s_id, ANY_VALUE(A.shop_id) AS shop_id, ANY_VALUE(A.s_nm_short) as s_nm_short, ANY_VALUE(A.shop_nm) AS shop_nm FROM idx_shoptotal as A left join idx_s AS B on A.s_id = B.s_id WHERE %{options} GROUP BY A.s_id ORDER BY s_sort ASC;" % [options: options ]

		return connection.select_all(query)
	end
	
			
	def self.selectinfo_with_shoplists(_shoplist)
		
		shops = _shoplist.split(',')
		options = nil
		shops.each do |shop|
			if options.blank?
				options = "A.shop_id = '#{shop}' "
			else
				options += "OR A.shop_id = '#{shop}' "
			end
		end
	
		query = "SELECT A.s_id, ANY_VALUE(A.shop_id) AS shop_id, ANY_VALUE(A.s_nm_short) as s_nm_short, ANY_VALUE(A.shop_nm) AS shop_nm FROM idx_shoptotal as A left join idx_s AS B on A.s_id = B.s_id WHERE %{options} GROUP BY A.s_id, A.shop_id ORDER BY s_sort ASC;" % [options: options ]

		return connection.select_all(query)
	end
	
	def self.selectinfo_with_shoplist2(_shoplist)
		
		shops = _shoplist.split(',')
		options = nil
		shops.each do |shop|
			if options.blank?
				options = "A.shop_id = '#{shop}' "
			else
				options += "OR A.shop_id = '#{shop}' "
			end
		end
	
		query = "SELECT A.s_id, ANY_VALUE(A.shop_id) AS shop_id, ANY_VALUE(A.s_nm_short) as s_nm_short, ANY_VALUE(A.shop_nm) AS shop_nm FROM idx_shoptotal as A left join idx_s AS B on A.s_id = B.s_id WHERE %{options} ORDER BY s_sort ASC;" % [options: options ]

		return connection.select_all(query)
	end
	
	#본사 제외
	def self.selectinfo_without_base
		query = "SELECT s_nm_short, s_id, FROM idx_shoptotal WHERE s_id = '%{id}' GROUP BY s_nm_short, s_id ORDER BY s_id"
		
		return connection.select_all(query)
	end
end