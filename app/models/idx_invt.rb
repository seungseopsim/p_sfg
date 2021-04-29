class IdxInvt < ApplicationRecord
	
	TABLE = 'idx_invt'.freeze
	COL = "h_id, s_id, shop_id, gd_id, gd_nm, unit_id, gdmr_id, live_yn, gd_bsn_unit_per, gd_bsn_unit_id, gd_stk_gd_per, memo, cret_usrid, cret_dt, mod_usrid, mod_dt".freeze
	
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
					logger.info "IDX_INVT INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "IDX_INVT RuntimeError #{runtimeerror}"
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
			gd_bsn_unit_per = data['GD_BSN_UNIT_PER'].blank? ? 'NULL' : data['GD_BSN_UNIT_PER']
			gd_stk_gd_per = data['GD_STK_GD_PER'].blank? ? 'NULL' : data['GD_STK_GD_PER']
			cret_dt = data['CRET_DT'].blank? ? 'NULL' : "'#{data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			mod_dt = data['MOD_DT'].blank? ? 'NULL' : "'#{data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			
			query = "SELECT h_id AS CNT FROM %{table} WHERE h_id = '%{h_id}' AND s_id = '%{s_id}' AND shop_id = '%{shop_id}' AND gd_id = '%{gd_id}';" % [table: TABLE, h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], gd_id: data['GD_ID']]
			
			result = connection.select_one(query)
	
			if result.present?
				value = "gd_nm = '%{gd_nm}', unit_id = '%{unit_id}', gdmr_id = '%{gdmr_id}', live_yn = '%{live_yn}', gd_bsn_unit_per = %{gd_bsn_unit_per}, gd_bsn_unit_id = '%{gd_bsn_unit_id}', gd_stk_gd_per = %{gd_stk_gd_per}, memo = '%{memo}', cret_usrid = '%{cret_usrid}', cret_dt = %{cret_dt}, mod_usrid = '%{mod_usrid}', mod_dt = %{mod_dt} " % [gd_nm: data['GD_NM'], unit_id: data['UNIT_ID'], gdmr_id: data['GDMR_ID'], live_yn: data['LIVE_YN'], gd_bsn_unit_per: gd_bsn_unit_per, gd_bsn_unit_id: data['GD_BSN_UNIT_ID'], gd_stk_gd_per: gd_stk_gd_per, memo: data['MEMO'], cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt ]
				
				bInsert = false		
				query = "UPDATE %{table} SET %{val} WHERE h_id = '%{h_id}' AND s_id = '%{s_id}' AND shop_id = '%{shop_id}' AND gd_id = '%{gd_id}';" % [table: TABLE, val: value, h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], gd_id: data['GD_ID']]
				
			else
				value = "'%{h_id}','%{s_id}','%{shop_id}','%{gd_id}','%{gd_nm}','%{unit_id}','%{gdmr_id}','%{live_yn}', %{gd_bsn_unit_per}, '%{gd_bsn_unit_id}', %{gd_stk_gd_per}, '%{memo}', '%{cret_usrid}', %{cret_dt}, '%{mod_usrid}', %{mod_dt}" % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], gd_id: data['GD_ID'], gd_nm: data['GD_NM'], unit_id: data['UNIT_ID'], gdmr_id: data['GDMR_ID'], live_yn: data['LIVE_YN'], gd_bsn_unit_per: gd_bsn_unit_per, gd_bsn_unit_id: data['GD_BSN_UNIT_ID'], gd_stk_gd_per: gd_stk_gd_per, memo: data['MEMO'], cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt ]
				
				bInsert = true
				query = "INSERT INTO %{table} (%{col}) VALUES(%{val}); " % [table: TABLE, col: COL, val: value ]
			end
				
			result = connection.execute(query)

		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "IDX_INVT INSERT Error #{exception}"
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
