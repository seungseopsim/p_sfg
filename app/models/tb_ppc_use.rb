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
                        puts result
                        @@insertThread = nil
					end
				end
			rescue => runtimeerror
				result = "#{TABLE} RuntimeError #{runtimeerror}"
                @@insertThread = nil
            ensure
                puts result
			end
        else
            result = "#{TABLE}-#{_day} INSERTING....#{@@insertThread.status}"
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
			puts "#{TABLE}-#{_day} CUBE DATA CNT #{cnt}"
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
			puts "#{TABLE}-#{_day} Insert Error #{exception}"
			cnt = -1
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
		
		log = nil

		transaction do
			query = "DELETE FROM %{table} WHERE bsn_dt = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
			cnt = connection.exec_delete(query)
			log = "#{TABLE}-#{_day} deletedata #{cnt}"
		rescue ActiveRecord::ActiveRecordError => exception
			log = "#{TABLE}-#{_day} deletedata Error #{exception}"
			result = false
            raise ActiveRecord::Rollback
        ensure
            puts log
		end
		
		return result
	end
	
	# insert value string
	private_class_method def self.getinsertvaluestring(_data)
		data = _data
		
		if data.blank?
			return nil
		end
	
		h_id = connection.quote(data['H_ID'])
		s_id = connection.quote(data['S_ID'])
		shop_id = connection.quote(data['SHOP_ID'])
		bsn_dt = data['BSN_DT'].blank? ? nil : data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")
		bsn_dt = connection.quote(bsn_dt)
		bsn_no = connection.quote(data['BSN_NO'])
		bc_no = connection.quote(data['BC_NO'])
		b_id = connection.quote(data['B_ID'])
		shop_nm = connection.quote(data['SHOP_NM'])
		shop_sort = connection.quote(data['SHOP_SORT'])
		bc_amt = connection.quote(data['BC_AMT'])
		bc_card_nb = connection.quote(data['BC_CARD_NB'])
		b_rcb_amt = connection.quote(data['B_RCB_AMT'])
		b_crt_amt = connection.quote(data['B_CRT_AMT'])
		b_cash_amt = connection.quote(data['B_CASH_AMT']) 
		b_cash_rct_yn = connection.quote(data['B_CASH_RCT_YN'])
		b_vcr_amt = connection.quote(data['B_VCR_AMT'])
		b_tick_amt = connection.quote(data['B_TICk_AMT'])
		b_pnt_amt = connection.quote(data['B_PNT_AMT'])
		b_svc_crg_amt = connection.quote(data['B_SVC_CRG_AMT'])
		b_vst_cnt = connection.quote(data['B_VST_CNT'])
		b_crg_dt = data['B_CRG_DT'].blank? ? nil : data['B_CRG_DT'].strftime("%Y-%m-%d %H:%M:%S")
		b_crg_dt = connection.quote(b_crg_dt)
		
		value = "#{h_id}, #{s_id}, #{shop_id}, #{bsn_dt}, #{bsn_no}, #{bc_no}, #{b_id}, #{shop_nm}, #{shop_sort}, #{bc_amt}, #{bc_card_nb}, #{b_rcb_amt}, #{b_crt_amt}, #{b_cash_amt}, #{b_cash_rct_yn}, #{b_vcr_amt}, #{b_tick_amt}, #{b_pnt_amt}, #{b_svc_crg_amt}, #{b_vst_cnt}, #{b_crg_dt}" 
		return "%{val}" % [val: value]
	end

end