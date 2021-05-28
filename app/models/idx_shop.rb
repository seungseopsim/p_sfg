class IdxShop < ApplicationRecord
	
	TABLE = 'idx_shop'.freeze
	COL = "h_id, s_id, shop_id, h_nm, s_nm, shop_nm, shoppt_nm, if_id, shop_suw_id, shop_biz_no, shop_onr_nm, shop_key_tel, shop_ads_info, b_id, memo, shop_open_dt, shop_close_dt, etax_shop_nm, cret_usrid, cret_dt, mod_usrid, mod_dt".freeze
	
	@@insertThread = nil

	def self.insert
		cubedata = Cubedb::VShIdxShop.selectall
		data = insertdata(cubedata)
		return "IDX_SHOP CUBE DATA CNT #{cubedata.length} : INSERT #{data}"
	end
	
	private_class_method def self.insertdata(_datas)
		insertCnt = 0
		updateCnt = 0
		bInsert = false
			
		if _datas.blank?
			return "Insert:#{insertCnt} / Update:#{updateCnt}"
		end	

		_datas.each do |data|
		begin
			h_id = connection.quote(data['H_ID'])
			s_id = connection.quote(data['S_ID'])
			shop_id = connection.quote(data['SHOP_ID'])
			h_nm = connection.quote(data['H_NM'])
			s_nm = connection.quote(data['S_NM'])
			shop_nm = connection.quote(data['SHOP_NM'])
			shoppt_nm = connection.quote(data['SHOPPT_NM'])
			if_id = connection.quote(data['IF_ID'])
			shop_suw_id = connection.quote(data['SHOP_SUW_ID'])
			shop_biz_no = connection.quote(data['SHOP_BIZ_NO'])
			shop_onr_nm = connection.quote(data['SHOP_ONR_NM'])
			shop_key_tel = connection.quote(data['SHOP_KEY_TEL'])
			shop_ads_info = connection.quote(data['SHOP_ADS_INFO'])
			b_id = connection.quote(data['B_ID'])
			memo = connection.quote(data['MEMO'])
			shop_open_dt = data['SHOP_OPEN_DT'].blank? ? nil : data['SHOP_OPEN_DT'].strftime("%Y-%m-%d %H:%M:%S")
			shop_open_dt = connection.quote(shop_open_dt)
			shop_close_dt = data['SHOP_CLOSE_DT'].blank? ? nil : data['SHOP_CLOSE_DT'].strftime("%Y-%m-%d %H:%M:%S")
			shop_close_dt = connection.quote(shop_close_dt)
			etax_shop_nm = connection.quote(data['ETAX_SHOP_NM'])
			cret_usrid = connection.quote(data['CRET_USRID'])
			cret_dt = data['CRET_DT'].blank? ? nil : data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")
			cret_dt = connection.quote(cret_dt)
			mod_usrid = connection.quote(data['MOD_USRID'])
			mod_dt = data['MOD_DT'].blank? ? nil : data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")
			mod_dt = connection.quote(mod_dt)
			
			query = "SELECT h_id AS CNT FROM #{TABLE} WHERE h_id = #{h_id} AND s_id = #{s_id} AND shop_id = #{shop_id};" 	
			result = connection.select_one(query)
	
			if result.present?
				value = "h_nm = #{h_nm}, s_nm = #{s_nm}, shop_nm = #{shop_nm}, shoppt_nm = #{shoppt_nm}, if_id = #{if_id}, shop_suw_id = #{shop_suw_id}, shop_biz_no = #{shop_biz_no}, shop_onr_nm = #{shop_onr_nm}, shop_key_tel = #{shop_key_tel}, shop_ads_info = #{shop_ads_info}, b_id = #{b_id}, memo = #{memo}, shop_open_dt = #{shop_open_dt}, shop_close_dt = #{shop_close_dt}, etax_shop_nm = #{etax_shop_nm}, cret_usrid = #{cret_usrid}, cret_dt = #{cret_dt}, mod_usrid = #{mod_usrid}, mod_dt = #{mod_dt}"
				bInsert = false
				query = "UPDATE #{TABLE} SET #{value} WHERE h_id = #{h_id} AND s_id = #{s_id} AND shop_id = #{shop_id};"
			else
				value = "#{h_id}, #{s_id}, #{shop_id}, #{h_nm}, #{s_nm}, #{shop_nm}, #{shoppt_nm}, #{if_id}, #{shop_suw_id}, #{shop_biz_no}, #{shop_onr_nm}, #{shop_key_tel}, #{shop_ads_info}, #{b_id}, #{memo}, #{shop_open_dt}, #{shop_close_dt}, #{etax_shop_nm}, #{cret_usrid}, #{cret_dt}, #{mod_usrid}, #{mod_dt}" 
				
				bInsert = true
				query = "INSERT INTO #{TABLE} (#{COL}) VALUES(#{value}); " 
			end
			
			transaction do
				result = connection.execute(query)
			end
		rescue ActiveRecord::ActiveRecordError => exception
			puts "IDX_SHOP DB Error #{exception}"
			next
		end
			if bInsert
				insertCnt += 1
			else
				updateCnt += 1
			end
		end	
	
		return "Insert:#{insertCnt} / Update:#{updateCnt}"
	end
	
end