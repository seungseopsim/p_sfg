class TbPpcSave < ApplicationRecord

	COL = 'h_id, s_id, ppc_no, ppce_no, b_id, shop_id, shop_nm, shop_sort, bsn_dt, ppce_amt, ppce_dt, bc_st, ppce_crg_cash_amt, ppce_crg_card_amt, ppce_crg_oln_amt, apv, ppce_apv_nb, card_nm, ppce_add_amt, ppce_use_amt, ppce_avb_amt, live_yn'.freeze
	TABLE = "tb_ppc_save".freeze
	@@insertThread = nil
    #@@semaphore = Mutex.new
        
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShPpcSave.selectall(_day)
		if cubedata.present?
			if deletedata(_day)
				data = insertdata(_day, cubedata)
				result = "#{TABLE}-#{_day} : CUBE DATA CNT #{cubedata.length} : INSERT #{data}"
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
				result = "#{TABLE}-#{_day} RuntimeError #{runtimeerror}"
                @@insertThread = nil
            ensure
                #Rails.logger.flush
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
		ppc_no = connection.quote(data['PPC_NO'])
		ppce_no = connection.quote(data['PPCE_NO'])
		b_id = connection.quote(data['B_ID'])
		shop_id = connection.quote(data['SHOP_ID'])
		shop_nm = connection.quote(data['SHOP_NM'])
		shop_sort = connection.quote(data['SHOP_SORT'])
		bsn_dt = data['BSN_DT'].blank? ? nil : data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")
		bsn_dt = connection.quote(bsn_dt)
		ppce_amt = connection.quote(data['PPCE_AMT'])
		ppce_dt = data['PPCE_DT'].blank? ? nil : data['PPCE_DT'].strftime("%Y-%m-%d %H:%M:%S")
		ppce_dt = connection.quote(ppce_dt)
		bc_st = connection.quote(data['BC_ST'])
		ppce_crg_cash_amt = connection.quote(data['PPCE_CRG_CASH_AMT'])
		ppce_crg_card_amt = connection.quote(data['PPCE_CRG_CARD_AMT'])
		ppce_crg_oln_amt = connection.quote(data['PPCE_CRG_OLN_AMT'])
		apv = connection.quote(data['APV'])
		ppce_apv_nb = connection.quote(data['PPCE_APV_NB'])
		card_nm = connection.quote(data['CARD_NM'])
		ppce_add_amt = connection.quote(data['PPCE_ADD_AMT'])
		ppce_use_amt = connection.quote(data['PPCE_USE_AMT'])
		ppce_avb_amt = connection.quote(data['PPCE_AVB_AMT'])
		live_yn = connection.quote(data['LIVE_YN'])

		value = "#{h_id}, #{s_id}, #{ppc_no}, #{ppce_no}, #{b_id}, #{shop_id}, #{shop_nm}, #{shop_sort}, #{bsn_dt}, #{ppce_amt}, #{ppce_dt}, #{bc_st}, #{ppce_crg_cash_amt}, #{ppce_crg_card_amt}, #{ppce_crg_oln_amt}, #{apv}, #{ppce_apv_nb}, #{card_nm}, #{ppce_add_amt}, #{ppce_use_amt}, #{ppce_avb_amt}, #{live_yn}"

		return "%{val}" % [val: value]
	end
end