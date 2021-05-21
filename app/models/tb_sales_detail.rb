class TbSalesDetail < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, bg_no, b_id, shop_nm, shop_sort, b_vst_cnt, gd_id, gd_nm, bg_st, bg_odr_st, bg_gd_st, bg_odr_dt, bg_stt_dt, bg_qty, bg_uc, bg_amt, bg_gd_dst_amt, bg_dst_amt, bg_real_amt, bg_svc_crg_amt, bg_vos_amt, bg_tax_amt, bg_apl_vos_amt, bg_apl_tax_amt, stb_id, bg_ord_sort_no, bg_ord_qty, bg_ord_pos_id, bg_mod_pos_id, del_id, bg_ccl_id, dst_id, bg_bf_bg_no, bg_bf_stb_id, bg_bill_msg, bg_rtn_id, bg_rtn_bsn_dt, bg_rtn_bsn_no, bg_rtn_bg_no, bg_new_gd_nm, live_yn, cret_usrid, cret_dt, mod_usrid, mod_dt'.freeze
	TABLE = 'tb_sales_detail'.freeze
	@@insertThread = nil
    #@@semaphore = Mutex.new
        
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedatacnt = Cubedb::VShSalesDetail.select_count(_day)
		if cubedatacnt.present?
			if deletedata(_day)
				1.step(cubedatacnt, DATAOFFSET) do | index |
					offset = index + DATAOFFSET
					cubedata = Cubedb::VShSalesDetail.select_range(_day, index, offset)
					data = insertdata(_day, cubedata)
					result = "#{_day}: #{TABLE} INSERT RANGE #{index}~#{offset} #{data}"
	                Rails.logger.info result
				end
				result = "#{TABLE}-#{_day} : CUBE DATA CNT #{cubedatacnt} : INSERT #{cubedatacnt}"
			else
				result = "#{TABLE}-#{_day} : INSERT ERROR"
			end	
		end
		#@@semaphore.synchronize do
        #    Rails.logger.info result
        #end
		return result
	end
	
	def self.insert_withThread(_day)
		result = "#{TABLE}-#{_day} INSERTING...."
		if( @@insertThread == nil)
			result = "#{TABLE}-#{_day} INSERT START...."
			begin
				@@insertThread = Thread.new do
					Rails.application.executor.wrap do
                        result = insert(_day)
                        Rails.logger.info result
                        @@insertThread = nil
					end
				end
			rescue => runtimeerror
				result = "#{TABLE}-#{_day} RuntimeError #{runtimeerror}"
				Rails.logger.error result
                @@insertThread = nil
            ensure
                Rails.logger.flush
            end 
		end
		return result
	end
	

private
	private_class_method def self.insertdata(_day, _datas)
		cnt = 0
				
		if _datas.blank?
			Rails.logger.info "#{TABLE}-#{_day} CUBE DATA CNT #{cnt}"
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
#			Rails.logger.error "#{TABLE}-#{_day} Insert Error #{exception}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE}-#{_day} Insert Error #{exception}"
			raise ActiveRecord::Rollback
		ensure
            query = nil
            Rails.logger.flush
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
			query = "DELETE FROM %{table} WHERE bsn_dt = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
			cnt = connection.exec_delete(query)
			Rails.logger.info "#{TABLE}-#{_day} deletedata #{cnt}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE}-#{_day} deletedata Error #{exception}"
			result = false
            raise ActiveRecord::Rollback
        ensure
            Rails.logger.flush
		end
		
		return result
	end
	
	# insert value string
	private_class_method def self.getinsertvaluestring(_data)
		data = _data
		
		if data.blank?
			return nil
		end
		
		bsn_dt = data['BSN_DT'].blank? ? 'NULL' : "'#{data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : "'#{data['SHOP_SORT']}'"
		b_vst_cnt = data['B_VST_CNT'].blank? ? 'NULL' : "'#{data['B_VST_CNT']}'"
		bg_odr_dt = data['BG_ODR_DT'].blank? ? 'NULL' : "'#{data['BG_ODR_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		bg_stt_dt = data['BG_STT_DT'].blank? ? 'NULL' : "'#{data['BG_STT_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		bg_qty = data['BG_QTY'].blank? ? 'NULL' : "'#{data['BG_QTY']}'"
		bg_uc = data['BG_UC'].blank? ? 'NULL' : "'#{data['BG_UC']}'"
		bg_amt = data['BG_AMT'].blank? ? 'NULL' : "'#{data['BG_AMT']}'"
		bg_gd_dst_amt = data['BG_GD_DST_AMT'].blank? ? 'NULL' : "'#{data['BG_GD_DST_AMT']}'"
		bg_dst_amt = data['BG_DST_AMT'].blank? ? 'NULL' : "'#{data['BG_DST_AMT']}'"
		bg_real_amt = data['BG_REAL_AMT'].blank? ? 'NULL' : "'#{data['BG_REAL_AMT']}'"
		bg_svc_crg_amt = data['BG_SVC_CRG_AMT'].blank? ? 'NULL' : "'#{data['BG_SVC_CRG_AMT']}'"
		bg_vos_amt = data['BG_VOS_AMT'].blank? ? 'NULL' : "'#{data['BG_VOS_AMT']}'"
		bg_tax_amt = data['BG_TAX_AMT'].blank? ? 'NULL' : "'#{data['BG_TAX_AMT']}'"
		bg_apl_vos_amt = data['BG_APL_VOS_AMT'].blank? ? 'NULL' : "'#{data['BG_APL_VOS_AMT']}'"
		bg_apl_tax_amt = data['BG_APL_TAX_AMT'].blank? ? 'NULL' : "'#{data['BG_APL_TAX_AMT']}'"
		bg_ord_sort_no = data['BG_ORD_SORT_NO'].blank? ? 'NULL' : "'#{data['BG_ORD_SORT_NO']}'"
		bg_ord_qty = data['BG_ORD_QTY'].blank? ? 'NULL' : "'#{data['BG_ORD_QTY']}'"
		bg_bf_bg_no = data['BG_BF_BG_NO'].blank? ? 'NULL' : "'#{data['BG_BF_BG_NO']}'"
		bg_rtn_bsn_dt = data['BG_RTN_BSN_DT'].blank? ? 'NULL' : "'#{data['BG_RTN_BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"			
		bg_rtn_bsn_no = data['BG_RTN_BSN_NO'].blank? ? 'NULL' : "'#{data['BG_RTN_BSN_NO']}'"
		bg_rtn_bg_no = data['BG_RTN_BG_NO'].blank? ? 'NULL' : "'#{data['BG_RTN_BG_NO']}'"
		cret_dt = data['CRET_DT'].blank? ? 'NULL' : "'#{data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		mod_dt = data['MOD_DT'].blank? ? 'NULL' : "'#{data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"

		value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, '%{bsn_no}', '%{bg_no}', '%{b_id}', \"%{shop_nm}\", %{shop_sort}, %{b_vst_cnt}, '%{gd_id}', \"%{gd_nm}\", '%{bg_st}', '%{bg_odr_st}', '%{bg_gd_st}', %{bg_odr_dt}, %{bg_stt_dt}, %{bg_qty}, %{bg_uc}, %{bg_amt}, %{bg_gd_dst_amt}, %{bg_dst_amt}, %{bg_real_amt}, %{bg_svc_crg_amt}, %{bg_vos_amt}, %{bg_tax_amt}, %{bg_apl_vos_amt}, %{bg_apl_tax_amt}, '%{stb_id}', %{bg_ord_sort_no}, %{bg_ord_qty}, '%{bg_ord_pos_id}', '%{bg_mod_pos_id}', '%{del_id}', '%{bg_ccl_id}', '%{dst_id}', %{bg_bf_bg_no}, '%{bg_bf_stb_id}', '%{bg_bill_msg}', '%{bg_rtn_id}', %{bg_rtn_bsn_dt}, %{bg_rtn_bsn_no}, %{bg_rtn_bg_no}, '%{bg_new_gd_nm}', '%{live_yn}', '%{cret_usrid}', %{cret_dt}, '%{mod_usrid}', %{mod_dt} " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, bsn_no: data['BSN_NO'], bg_no: data['BG_NO'], b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, b_vst_cnt: b_vst_cnt, gd_id: data['GD_ID'], gd_nm: data['GD_NM'], bg_st: data['BG_ST'], bg_odr_st: data['BG_ODR_ST'], bg_gd_st: data['BG_GD_ST'], bg_odr_dt: bg_odr_dt, bg_stt_dt: bg_stt_dt, bg_qty: bg_qty, bg_uc: bg_uc, bg_amt: bg_amt, bg_gd_dst_amt: bg_gd_dst_amt, bg_dst_amt: bg_dst_amt, bg_real_amt: bg_real_amt, bg_svc_crg_amt: bg_svc_crg_amt, bg_vos_amt: bg_vos_amt, bg_tax_amt: bg_tax_amt, bg_apl_vos_amt: bg_apl_vos_amt, bg_apl_tax_amt: bg_apl_tax_amt, stb_id: data['STB_ID'], bg_ord_sort_no: bg_ord_sort_no, bg_ord_qty: bg_ord_qty, bg_ord_pos_id: data['BG_ORD_POS_ID'], bg_mod_pos_id: data['BG_MOD_POS_ID'], del_id: data['DEL_ID'], bg_ccl_id: data['BG_CCL_ID'], dst_id: data['DST_ID'], bg_bf_bg_no: bg_bf_bg_no, bg_bf_stb_id: data['BG_BF_STB_ID'], bg_bill_msg: data['BG_BILL_MSG'], bg_rtn_id: data['BG_RTN_ID'], bg_rtn_bsn_dt: bg_rtn_bsn_dt, bg_rtn_bsn_no: bg_rtn_bsn_no, bg_rtn_bg_no: bg_rtn_bg_no, bg_new_gd_nm: data['BG_NEW_GD_NM'], live_yn: data['LIVE_YN'], cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt ]

		return "%{val}" % [val: value]
	end
end