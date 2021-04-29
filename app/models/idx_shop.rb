class IdxShop < ApplicationRecord
	
	TABLE = 'idx_shop'.freeze
	COL = "h_id, s_id, shop_id, h_nm, s_nm, shop_nm, shoppt_nm, if_id, shop_suw_id, shop_biz_no, shop_onr_nm, shop_key_tel, shop_ads_info, b_id, memo, shop_open_dt, shop_close_dt, etax_shop_nm, cret_usrid, cret_dt, mod_usrid, mod_dt".freeze
	
	@@insertThread = nil
=begin
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "IDX_SHOP INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "IDX_SHOP RuntimeError #{runtimeerror}"
			@@insertThread.exit
			@@insertThread = nil
		end

		#ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
		#	@@insertThread.join
		#end
				
		return 'Insert Start'

	end
		
	private
	def self.insertdata(_datas)
=end
	def self.insert(_datas)
		insertCnt = 0
		updateCnt = 0
		bInsert = false
			
		if _datas.blank?
			return "Insert:#{insertCnt} / Update:#{updateCnt}"
		end	

		_datas.each do |data|
		begin
			shop_open_dt = data['SHOP_OPEN_DT'].blank? ? 'NULL' : "'#{data['SHOP_OPEN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			shop_close_dt = data['SHOP_CLOSE_DT'].blank? ? 'NULL' : "'#{data['SHOP_CLOSE_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			cret_dt = data['CRET_DT'].blank? ? 'NULL' : "'#{data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			mod_dt = data['MOD_DT'].blank? ? 'NULL' : "'#{data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			
			query = "SELECT h_id AS CNT FROM %{table} WHERE h_id = '%{h_id}' AND s_id = '%{s_id}' AND shop_id = '%{shop_id}';" % [ table: TABLE, h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'] ]
			
			result = connection.select_one(query)
	
			if result.present?
				value = " h_nm = '%{h_nm}', s_nm = '%{s_nm}', shop_nm = '%{shop_nm}', shoppt_nm = '%{shoppt_nm}', if_id = '%{if_id}', shop_suw_id = '%{shop_suw_id}', shop_biz_no = '%{shop_biz_no}', shop_onr_nm = '%{shop_onr_nm}', shop_key_tel = '%{shop_key_tel}', shop_ads_info = '%{shop_ads_info}', b_id = '%{b_id}', memo = '%{memo}', shop_open_dt = %{shop_open_dt}, shop_close_dt = %{shop_close_dt}, etax_shop_nm = '%{etax_shop_nm}', cret_usrid = '%{cret_usrid}', cret_dt = %{cret_dt}, mod_usrid = '%{mod_usrid}', mod_dt = %{mod_dt} " % [ h_nm: data['H_NM'], s_nm: data['S_NM'], shop_nm: data['SHOP_NM'], shoppt_nm: data['SHOPPT_NM'], if_id: data['IF_ID'], shop_suw_id: data['SHOP_SUW_ID'], shop_biz_no:  data['SHOP_BIZ_NO'], shop_onr_nm: data['SHOP_ONR_NM'], shop_key_tel: data['SHOP_KEY_TEL'], shop_ads_info: data['SHOP_ADS_INFO'], b_id: data['B_ID'], memo: data['MEMO'], shop_open_dt: shop_open_dt, shop_close_dt: shop_close_dt, etax_shop_nm: data['ETAX_SHOP_NM'], cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt ]
				
				bInsert = false
				query = "UPDATE %{table} SET %{val} WHERE h_id = '%{h_id}' AND s_id = '%{s_id}' AND shop_id = '%{shop_id}';" % [table: TABLE, col: COL, val: value, h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'] ]
			else
				value = "'%{h_id}','%{s_id}','%{shop_id}','%{h_nm}','%{s_nm}', '%{shop_nm}','%{shoppt_nm}','%{if_id}','%{shop_suw_id}','%{shop_biz_no}','%{shop_onr_nm}','%{shop_key_tel}','%{shop_ads_info}','%{b_id}', '%{memo}', %{shop_open_dt}, %{shop_close_dt},'%{etax_shop_nm}', '%{cret_usrid}', %{cret_dt}, '%{mod_usrid}', %{mod_dt}" % [h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], h_nm: data['H_NM'], s_nm: data['S_NM'], shop_nm: data['SHOP_NM'], shoppt_nm: data['SHOPPT_NM'], if_id: data['IF_ID'], shop_suw_id: data['SHOP_SUW_ID'], shop_biz_no:  data['SHOP_BIZ_NO'], shop_onr_nm: data['SHOP_ONR_NM'], shop_key_tel: data['SHOP_KEY_TEL'], shop_ads_info: data['SHOP_ADS_INFO'], b_id: data['B_ID'], memo: data['MEMO'], shop_open_dt: shop_open_dt, shop_close_dt: shop_close_dt, etax_shop_nm: data['ETAX_SHOP_NM'], cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt ]
				
				bInsert = true
				query = "INSERT INTO %{table} (%{col}) VALUES(%{val}); " % [table: TABLE, col: COL, val: value ]
			end
			
			result = connection.execute(query)
			
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "IDX_SHOP Insert Error #{exception}"
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