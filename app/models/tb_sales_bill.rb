class TbSalesBill < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, b_id, shop_nm, shop_sort, stb_id, b_odr_dt, b_crg_dt, b_odr_st, b_st, b_ccl_amt, b_dst_amt, b_rcb_amt, b_vst_cnt, live_yn, b_crt_amt, b_cash_amt, b_etc_amt, gd_nm'.freeze
	TABLE = "tb_sales_bill".freeze
	@@insertThread = nil

	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		cubedata = Cubedb::VShSalesBill.selectall(_day)
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
#		rescue ActiveRecord::RecordNotUnique 
#			Rails.logger.error "TB_COS_DAILY Insert Error #{exception}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE} Insert Error #{exception}"
			raise ActiveRecord::Rollback
		ensure
			query = nil
		end

		return cnt
	end
	
	private_class_method def self.deletedata(_day)
		result = true
		if _day.blank?
			return false
		end	
		
		transaction do
			query = "DELETE FROM %{table} WHERE bsn_dt = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
			cnt = connection.exec_delete(query)
			Rails.logger.info "#{TABLE} deletedata #{cnt}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE} deletedata Error #{exception}"
			result = false
			raise ActiveRecord::Rollback
		end

		return result
	end
	
	
	private_class_method def self.getinsertvaluestring(_data)
		data = _data
		
		if data.blank?
			return nil
		end
		
		bsn_dt = data['BSN_DT'].blank? ? 'NULL' : "'#{data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		bsn_no = data['BSN_NO'].blank? ? 'NULL' : data['BSN_NO']
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		b_odr_dt = data['B_ODR_DT'].blank? ? 'NULL' : "'#{data['B_ODR_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		b_crg_dt = data['B_CRG_DT'].blank? ? 'NULL' : "'#{data['B_CRG_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		b_ccl_amt = data['B_CCL_AMT'].blank? ? 'NULL' : data['B_CCL_AMT']
		b_dst_amt = data['B_DST_AMT'].blank? ? 'NULL' : data['B_DST_AMT']
		b_rcb_amt = data['B_RCB_AMT'].blank? ? 'NULL' : data['B_RCB_AMT']
		b_vst_cnt = data['B_VST_CNT'].blank? ? 'NULL' : data['B_VST_CNT']
		b_crt_amt = data['B_CRT_AMT'].blank? ? 'NULL' : data['B_CRT_AMT']
		b_cash_amt = data['B_CASH_AMT'].blank? ? 'NULL' : data['B_CASH_AMT']
		b_etc_amt = data['B_ETC_AMT'].blank? ? 'NULL' : data['B_ETC_AMT']
			
		value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, %{bsn_no}, '%{b_id}', \"%{shop_nm}\", %{shop_sort}, '%{stb_id}', %{b_odr_dt}, %{b_crg_dt}, '%{b_odr_st}', '%{b_st}', %{b_ccl_amt}, %{b_dst_amt}, %{b_rcb_amt}, %{b_vst_cnt}, '%{live_yn}', %{b_crt_amt}, %{b_cash_amt}, %{b_etc_amt}, \"%{gd_nm}\" " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, bsn_no: bsn_no, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, stb_id: data['STB_ID'], b_odr_dt: b_odr_dt, b_crg_dt: b_crg_dt, b_odr_st: data['B_ODR_ST'], b_st: data['B_ST'], b_ccl_amt: b_ccl_amt, b_dst_amt: b_dst_amt, b_rcb_amt: b_rcb_amt, b_vst_cnt: b_vst_cnt, live_yn: data['LIVE_YN'], b_crt_amt: b_crt_amt, b_cash_amt: b_cash_amt, b_etc_amt: b_etc_amt, gd_nm: data['GD_NM'] ]

		return "%{val}" % [val: value]
	end

end