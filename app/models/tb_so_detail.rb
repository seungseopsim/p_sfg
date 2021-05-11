class TbSoDetail < ApplicationRecord

	COL = 'h_id, s_id, shop_id, so_dt, so_no, sog_no, b_id, shop_nm, shop_sort, gd_id, sog_jc_st, unit_id, unit_nm, sog_qty, sog_uc, sog_amt, sog_real_amt, sog_vos_amt, sog_tax_amt, sog_taxf_amt, sog_ccl_amt, sog_tax_st, sog_odr_qty, sog_rcv_qty, sog_si_qty, trd_id, trd_nm, gd_nm, live_yn, memo, info, sort_no, cret_usrid, cret_dt, mod_usrid, mod_dt, gdmr_id, gdmj_id, gdmr_nm, gdmj_nm'.freeze
	TABLE = "tb_so_detail".freeze
	@@insertThread = nil
	
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShSoDetail.selectall(_day)
		if cubedata.present?
			if deletedata(_day)
				data = insertdata(cubedata)
				result = "#{TABLE}-#{_day} : CUBE DATA CNT #{cubedata.length} : INSERT #{data}"
			else
				result = "#{TABLE}-#{_day} : INSERT ERROR"
			end
		end
		
		Rails.logger.info result
		return result
	end
	
	def self.insert_withThread(_day)
		result = "#{TABLE} INSERTING...."
		
		if @@insertThread == nil
			result = "#{TABLE} INSERT START...."
			begin
				@@insertThread = Thread.new do
					Rails.application.executor.wrap do
						insert(_day)
						@@insertThread = nil
					end
				end
			rescue RuntimeError => runtimeerror
				Rails.logger.error "#{TABLE} RuntimeError #{runtimeerror}"
				@@insertThread.exit
				@@insertThread = nil
			end

			#ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
			#	@@insertThread.join
			#end
		end
		
		return result
	end
	
	private
	
	private_class_method def self.insertdata(_datas)
		cnt = 0
				
		if _datas.blank?
			Rails.logger.info "#{TABLE} CUBE DATA CNT #{cnt}"
			return cnt
		end	
		
		cnt = _datas.length
	
		value = getinsertvaluestring(_datas[0])
		query = "INSERT INTO %{table} (%{col}) VALUES (%{val})" % [table: TABLE, col: COL, val: value]
		
		for index in 1...cnt
			value = getinsertvaluestring(_datas[index])
			query += ", (%{val})" % [val: value]
		end
		
		query += ';'

		transaction do
			connection.exec_query(query)
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE} Insert Error #{exception}"
			cnt = exception
			raise ActiveRecord::Rollback
		ensure
			query = nil
		end

		return cnt
	end
	
	# 삭제
	private_class_method def self.deletedata(_day)
		result = true
		if _day.blank?
			return false
		end	

		transaction do
			query = "DELETE FROM %{table} WHERE so_dt = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
			cnt = connection.exec_delete(query)
			Rails.logger.info "#{TABLE} deletedata #{cnt}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE} deletedata Error #{exception}"
			result = false
			raise ActiveRecord::Rollback
		end
		
		return result
	end
	
	# insert value string
	private_class_method def self.getinsertvaluestring(_data)
		data = _data
		if data.blank?
			return nil
		end
	
		so_dt = data['SO_DT'].blank? ? 'NULL' : "'#{data['SO_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		sog_qty = data['SOG_QTY'].blank? ? 'NULL' : data['SOG_QTY']
		sog_uc = data['SOG_UC'].blank? ? 'NULL' : data['SOG_UC']
		sog_amt = data['SOG_AMT'].blank? ? 'NULL' : data['SOG_AMT']
		sog_real_amt = data['SOG_REAL_AMT'].blank? ? 'NULL' : data['SOG_REAL_AMT']
		sog_vos_amt = data['SOG_VOS_AMT'].blank? ? 'NULL' : data['SOG_VOS_AMT']
		sog_tax_amt = data['SOG_TAX_AMT'].blank? ? 'NULL' : data['SOG_TAX_AMT']
		sog_taxf_amt = data['SOG_TAXF_AMT'].blank? ? 'NULL' : data['SOG_TAXF_AMT']
		sog_ccl_amt = data['SOG_CCL_AMT'].blank? ? 'NULL' : data['SOG_CCL_AMT']
		sog_odr_qty = data['SOG_ODR_QTY'].blank? ? 'NULL' : data['SOG_ODR_QTY']
		sog_rcv_qty = data['SOG_RCV_QTY'].blank? ? 'NULL' : data['SOG_RCV_QTY']
		sog_si_qty = data['SOG_SI_QTY'].blank? ? 'NULL' : data['SOG_SI_QTY']
		sort_no = data['SORT_NO'].blank? ? 'NULL' : data['SORT_NO']
		cret_dt = data['CRET_DT'].blank? ? 'NULL' : "'#{data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		mod_dt = data['MOD_DT'].blank? ? 'NULL' : "'#{data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"

		value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{so_dt}, %{so_no}, %{sog_no}, '%{b_id}', \"%{shop_nm}\", %{shop_sort}, '%{gd_id}', '%{sog_jc_st}', '%{unit_id}', \"%{unit_nm}\", %{sog_qty}, %{sog_uc}, %{sog_amt}, %{sog_real_amt}, %{sog_vos_amt}, %{sog_tax_amt}, %{sog_taxf_amt}, %{sog_ccl_amt}, '%{sog_tax_st}', %{sog_odr_qty}, %{sog_rcv_qty}, %{sog_si_qty}, '%{trd_id}', \"%{trd_nm}\", \"%{gd_nm}\", '%{live_yn}', \"%{memo}\", '%{info}', %{sort_no}, '%{cret_usrid}', %{cret_dt}, '%{mod_usrid}', %{mod_dt}, '%{gdmr_id}', '%{gdmj_id}', \"%{gdmr_nm}\", \"%{gdmj_nm}\" " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], so_dt: so_dt, so_no: data['SO_NO'], sog_no: data['SOG_NO'], b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, gd_id: data['GD_ID'], sog_jc_st: data['SOG_JC_ST'], unit_id: data['UNIT_ID'], unit_nm: data['UNIT_NM'], sog_qty: sog_qty, sog_uc: sog_uc, sog_amt: sog_amt, sog_real_amt: sog_real_amt, sog_vos_amt: sog_vos_amt, sog_tax_amt: sog_tax_amt, sog_taxf_amt: sog_taxf_amt, sog_ccl_amt: sog_ccl_amt, sog_tax_st: data['SOG_TAX_ST'], sog_odr_qty: sog_odr_qty, sog_rcv_qty: sog_rcv_qty, sog_si_qty: sog_si_qty, trd_id: data['TRD_ID'], trd_nm: data['TRD_NM'], gd_nm: data['GD_NM'], live_yn: data['LIVE_YN'], memo: data['MEMO'], info: data['INFO'], sort_no: sort_no, cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt, gdmr_id: data['GDMR_ID'], gdmj_id: data['GDMJ_ID'], gdmr_nm: data['GDMJ_NM'], gdmj_nm: data['GDMJ_NM'] ]

		return "%{val}" % [val: value]
	end
end