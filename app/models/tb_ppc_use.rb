class TbPpcUse < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, bc_no, b_id, shop_nm, shop_sort, bc_amt, bc_card_nb, b_rcb_amt, b_crt_amt, b_cash_amt, b_cash_rct_yn, b_vcr_amt, b_tick_amt, b_pnt_amt, b_svc_crg_amt, b_vst_cnt, b_crg_dt'.freeze
		
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_PPC_USE INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_PPC_USE RuntimeError #{runtimeerror}"
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
		cnt = 0
		
		if _datas.blank?
			return cnt
		end	
		
		_datas.each do |data|
		begin
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
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, %{bsn_no}, %{bc_no}, '%{b_id}', '%{shop_nm}', %{shop_sort}, %{bc_amt}, '%{bc_card_nb}', %{b_rcb_amt}, %{b_crt_amt}, %{b_cash_amt}, '%{b_cash_rct_yn}', %{b_vcr_amt}, %{b_tick_amt}, %{b_pnt_amt}, %{b_svc_crg_amt}, %{b_vst_cnt}, %{b_crg_dt} " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, bsn_no: bsn_no, bc_no: bc_no, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, bc_amt: bc_amt, bc_card_nb: data['BC_CARD_NB'], b_rcb_amt: b_rcb_amt, b_crt_amt: b_crt_amt, b_cash_amt: b_cash_amt, b_cash_rct_yn: data['B_CASH_RCT_YN'], b_vcr_amt: b_vcr_amt, b_tick_amt: b_tick_amt, b_pnt_amt: b_pnt_amt, b_svc_crg_amt: b_svc_crg_amt, b_vst_cnt: b_vst_cnt, b_crg_dt: b_crg_dt ]
					
			query = "INSERT INTO tb_ppc_use (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
						
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_PPC_USE Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end

end