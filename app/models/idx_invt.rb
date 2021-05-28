class IdxInvt < ApplicationRecord
	
	TABLE = 'idx_invt'.freeze
	COL = "h_id, s_id, shop_id, gd_id, gd_nm, unit_id, gdmr_id, live_yn, gd_bsn_unit_per, gd_bsn_unit_id, gd_stk_gd_per, memo, cret_usrid, cret_dt, mod_usrid, mod_dt".freeze
	
	def self.insert
		cubedata = Cubedb::VShIdxInvt.selectall
		data = insertdata(cubedata)
		return "IDX_INVT CUBE DATA CNT #{cubedata.length} : INSERT #{data}"
	end

	def self.insertdata(_datas)
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
			gd_id = connection.quote(data['GD_ID'])
			gd_nm = connection.quote(data['GD_NM'])
			unit_id = connection.quote(data['UNIT_ID'])
			gdmr_id = connection.quote(data['GDMR_ID'])
			live_yn = connection.quote(data['LIVE_YN'])
			gd_bsn_unit_per = connection.quote(data['GD_BSN_UNIT_PER'])
			gd_bsn_unit_id = connection.quote(data['GD_BSN_UNIT_ID'])
			gd_stk_gd_per = connection.quote(data['GD_STK_GD_PER'])
			memo = connection.quote(data['MEMO'])
			cret_usrid = connection.quote(data['CRET_USRID'])
			cret_dt = data['CRET_DT'].blank? ? nil : data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")
			cret_dt = connection.quote(cret_dt)
			mod_usrid = connection.quote(data['MOD_USRID'])
			mod_dt = data['MOD_DT'].blank? ? nil : data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")
			mod_dt = connection.quote(mod_dt)
			
			query = "SELECT h_id AS CNT FROM #{TABLE} WHERE h_id = #{h_id} AND s_id = #{s_id} AND shop_id = #{shop_id} AND gd_id = #{gd_id};" 
			
			result = connection.select_one(query)
	
			if result.present?
				value = "gd_nm = #{gd_nm}, unit_id = #{unit_id}, gdmr_id = #{gdmr_id}, live_yn = #{live_yn}, gd_bsn_unit_per = #{gd_bsn_unit_per}, gd_bsn_unit_id = #{gd_bsn_unit_id}, gd_stk_gd_per = #{gd_stk_gd_per}, memo = #{memo}, cret_usrid = #{cret_usrid}, cret_dt = #{cret_dt}, mod_usrid = #{mod_usrid}, mod_dt = #{mod_dt} " 
				
				bInsert = false		
				query = "UPDATE #{TABLE} SET #{value} WHERE h_id = #{h_id} AND s_id = #{s_id} AND shop_id = #{shop_id} AND gd_id = #{gd_id};" 
				
			else
				value = "#{h_id}, #{s_id}, #{shop_id}, #{gd_id}, #{gd_nm}, #{unit_id}, #{gdmr_id}, #{live_yn}, #{gd_bsn_unit_per}, #{gd_bsn_unit_id}, #{gd_stk_gd_per}, #{memo}, #{cret_usrid}, #{cret_dt}, #{mod_usrid}, #{mod_dt}"
				
				bInsert = true
				query = "INSERT INTO #{TABLE} (#{COL}) VALUES(#{value}); " 
			end
			
			transaction do
				result = connection.execute(query)
			end
		rescue ActiveRecord::ActiveRecordError => exception
			puts "IDX_INVT DB Error #{exception}"
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
