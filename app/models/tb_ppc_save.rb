class TbPpcSave < ApplicationRecord

	COL = 'h_id, s_id, ppc_no, ppce_no, b_id, shop_id, shop_nm, shop_sort, bsn_dt, ppce_amt, ppce_dt, bc_st, ppce_crg_cash_amt, ppce_crg_card_amt, ppce_crg_oln_amt, apv, ppce_apv_nb, card_nm, ppce_add_amt, ppce_use_amt, ppce_avb_amt, live_yn'.freeze
		
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_PPC_SAVE INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_PPC_SAVE RuntimeError #{runtimeerror}"
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
		if _datas.blank?
			return
		end	
		
		cnt = 0
		_datas.each do |data|
		begin
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
			
			
			value = " '%{h_id}', '%{s_id}', '%{ppc_no}', '%{ppce_no}', '%{b_id}', '%{shop_id}', '%{shop_nm}', %{shop_sort}, %{bsn_dt}, %{ppce_amt}, %{ppce_dt}, '%{bc_st}', %{ppce_crg_cash_amt}, %{ppce_crg_card_amt}, %{ppce_crg_oln_amt}, '%{apv}', '%{ppce_apv_nb}', '%{card_nm}', %{ppce_add_amt}, %{ppce_use_amt}, %{ppce_avb_amt}, '%{live_yn}' " % [ h_id: data['H_ID'], s_id: data['S_ID'], ppc_no: data['PPC_NO'], ppce_no: data['PPCE_NO'], b_id: data['B_ID'], shop_id: data['SHOP_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, bsn_dt: bsn_dt, ppce_amt: ppce_amt, ppce_dt: ppce_dt, bc_st: data['BC_ST'], ppce_crg_cash_amt: ppce_crg_cash_amt, ppce_crg_card_amt: ppce_crg_card_amt, ppce_crg_oln_amt: ppce_crg_oln_amt, apv: data['APV'], ppce_apv_nb: data['PPCE_APV_NB'], card_nm: data['CARD_NM'], ppce_add_amt: ppce_add_amt, ppce_use_amt: ppce_use_amt, ppce_avb_amt: ppce_avb_amt, live_yn: data['LIVE_YN'] ]
					
			query = "INSERT INTO tb_ppc_save (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
						
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_PPC_SAVE Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end
		
end