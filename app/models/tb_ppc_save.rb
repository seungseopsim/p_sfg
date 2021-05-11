class TbPpcSave < ApplicationRecord

	COL = 'h_id, s_id, ppc_no, ppce_no, b_id, shop_id, shop_nm, shop_sort, bsn_dt, ppce_amt, ppce_dt, bc_st, ppce_crg_cash_amt, ppce_crg_card_amt, ppce_crg_oln_amt, apv, ppce_apv_nb, card_nm, ppce_add_amt, ppce_use_amt, ppce_avb_amt, live_yn'.freeze
	TABLE = "tb_ppc_save".freeze
	@@insertThread = nil
	
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShPpcSave.selectall(_day)
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
			cnt = 0
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
	
	# insert value string
	private_class_method def self.getinsertvaluestring(_data)
		data = _data
		if data.blank?
			return nil
		end
		
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		bsn_dt = data['BSN_DT'].blank? ? 'NULL' : "'#{data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		ppce_amt = data['PPCE_AMT'].blank? ? 'NULL' : data['PPCE_AMT']
		ppce_dt = data['PPCE_DT'].blank? ? 'NULL' : "'#{data['PPCE_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		ppce_crg_cash_amt = data['PPCE_CRG_CASH_AMT'].blank? ? 'NULL' : data['PPCE_CRG_CASH_AMT']
		ppce_crg_card_amt = data['PPCE_CRG_CARD_AMT'].blank? ? 'NULL' : data['PPCE_CRG_CARD_AMT']
		ppce_crg_oln_amt = data['PPCE_CRG_OLN_AMT'].blank? ? 'NULL' : data['PPCE_CRG_OLN_AMT']
		ppce_add_amt = data['PPCE_ADD_AMT'].blank? ? 'NULL' : data['PPCE_ADD_AMT']
		ppce_use_amt = data['PPCE_USE_AMT'].blank? ? 'NULL' : data['PPCE_USE_AMT']
		ppce_avb_amt = data['PPCE_AVB_AMT'].blank? ? 'NULL' : data['PPCE_AVB_AMT']

		value = " '%{h_id}', '%{s_id}', '%{ppc_no}', '%{ppce_no}', '%{b_id}', '%{shop_id}', \"%{shop_nm}\", %{shop_sort}, %{bsn_dt}, %{ppce_amt}, %{ppce_dt}, '%{bc_st}', %{ppce_crg_cash_amt}, %{ppce_crg_card_amt}, %{ppce_crg_oln_amt}, '%{apv}', '%{ppce_apv_nb}', \"%{card_nm}\", %{ppce_add_amt}, %{ppce_use_amt}, %{ppce_avb_amt}, '%{live_yn}' " % [ h_id: data['H_ID'], s_id: data['S_ID'], ppc_no: data['PPC_NO'], ppce_no: data['PPCE_NO'], b_id: data['B_ID'], shop_id: data['SHOP_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, bsn_dt: bsn_dt, ppce_amt: ppce_amt, ppce_dt: ppce_dt, bc_st: data['BC_ST'], ppce_crg_cash_amt: ppce_crg_cash_amt, ppce_crg_card_amt: ppce_crg_card_amt, ppce_crg_oln_amt: ppce_crg_oln_amt, apv: data['APV'], ppce_apv_nb: data['PPCE_APV_NB'], card_nm: data['CARD_NM'], ppce_add_amt: ppce_add_amt, ppce_use_amt: ppce_use_amt, ppce_avb_amt: ppce_avb_amt, live_yn: data['LIVE_YN'] ]

		return "%{val}" % [val: value]
	end
end