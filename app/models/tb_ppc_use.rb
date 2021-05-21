class TbPpcUse < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, bc_no, b_id, shop_nm, shop_sort, bc_amt, bc_card_nb, b_rcb_amt, b_crt_amt, b_cash_amt, b_cash_rct_yn, b_vcr_amt, b_tick_amt, b_pnt_amt, b_svc_crg_amt, b_vst_cnt, b_crg_dt'.freeze
	TABLE = "tb_ppc_use".freeze
	@@insertThread = nil
    #@@semaphore = Mutex.new
        
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShPpcUse.selectall(_day)
		if cubedata.present?
			if deletedata(_day)
				data = insertdata(_day, cubedata)
				result = "#{TABLE}-#{_day} : CUBE DATA CNT #{cubedata.length} : INSERT #{data}"
			else
				result = "#{TABLE}-#{_day} : INSERT ERROR"
			end
		end
		
		return result
	end
	
	def self.insert_withThread(_day)
		result = "#{TABLE}-#{_day} INSERTING...."
		
		if @@insertThread == nil
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
				Rails.logger.error "#{TABLE} RuntimeError #{runtimeerror}"
                @@insertThread = nil
            ensure
                Rails.logger.flush
			end

			#ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
			#	@@insertThread.join
			#end
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
#			Rails.logger.error "TB_COS_DAILY Insert Error #{exception}"
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "#{TABLE}-#{_day} Insert Error #{exception}"
			cnt = 0
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
		bsn_no = data['BSN_NO'].blank? ? 'NULL' : data['BSN_NO']
		bc_no = data['BC_NO'].blank? ? 'NULL' : data['BC_NO']
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		bc_amt = data['BC_AMT'].blank? ? 'NULL' : data['BC_AMT']
		b_rcb_amt = data['B_RCB_AMT'].blank? ? 'NULL' : data['B_RCB_AMT']
		b_crt_amt = data['B_CRT_AMT'].blank? ? 'NULL' : data['B_CRT_AMT']
		b_cash_amt = data['B_CASH_AMT'].blank? ? 'NULL' : data['B_CASH_AMT']
		b_vcr_amt = data['B_VCR_AMT'].blank? ? 'NULL' : data['B_VCR_AMT']
		b_tick_amt = data['B_TICK_AMT'].blank? ? 'NULL' : data['B_TICK_AMT']
		b_pnt_amt = data['B_PNT_AMT'].blank? ? 'NULL' : data['B_PNT_AMT']
		b_svc_crg_amt = data['B_SVC_CRG_AMT'].blank? ? 'NULL' : data['B_SVC_CRG_AMT']
		b_vst_cnt = data['B_VST_CNT'].blank? ? 'NULL' : data['B_VST_CNT']
		b_crg_dt = data['B_CRG_DT'].blank? ? 'NULL' : "'#{data['B_CRG_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"

		value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, %{bsn_no}, %{bc_no}, '%{b_id}', \"%{shop_nm}\", %{shop_sort}, %{bc_amt}, '%{bc_card_nb}', %{b_rcb_amt}, %{b_crt_amt}, %{b_cash_amt}, '%{b_cash_rct_yn}', %{b_vcr_amt}, %{b_tick_amt}, %{b_pnt_amt}, %{b_svc_crg_amt}, %{b_vst_cnt}, %{b_crg_dt} " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, bsn_no: bsn_no, bc_no: bc_no, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, bc_amt: bc_amt, bc_card_nb: data['BC_CARD_NB'], b_rcb_amt: b_rcb_amt, b_crt_amt: b_crt_amt, b_cash_amt: b_cash_amt, b_cash_rct_yn: data['B_CASH_RCT_YN'], b_vcr_amt: b_vcr_amt, b_tick_amt: b_tick_amt, b_pnt_amt: b_pnt_amt, b_svc_crg_amt: b_svc_crg_amt, b_vst_cnt: b_vst_cnt, b_crg_dt: b_crg_dt ]

		return "%{val}" % [val: value]
	end
end