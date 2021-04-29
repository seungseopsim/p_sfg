class TbSalesBill < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, b_id, shop_nm, shop_sort, stb_id, b_odr_dt, b_crg_dt, b_odr_st, b_st, b_ccl_amt, b_dst_amt, b_rcb_amt, b_vst_cnt, live_yn, b_crt_amt, b_cash_amt, b_etc_amt, gd_nm'.freeze
		
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_SALES_BILL INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_SALES_BILL RuntimeError #{runtimeerror}"
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
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, %{bsn_no}, '%{b_id}', '%{shop_nm}', %{shop_sort}, '%{stb_id}', %{b_odr_dt}, %{b_crg_dt}, '%{b_odr_st}', '%{b_st}', %{b_ccl_amt}, %{b_dst_amt}, %{b_rcb_amt}, %{b_vst_cnt}, '%{live_yn}', %{b_crt_amt}, %{b_cash_amt}, %{b_etc_amt}, '%{gd_nm}' " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, bsn_no: bsn_no, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, stb_id: data['STB_ID'], b_odr_dt: b_odr_dt, b_crg_dt: b_crg_dt, b_odr_st: data['B_ODR_ST'], b_st: data['B_ST'], b_ccl_amt: b_ccl_amt, b_dst_amt: b_dst_amt, b_rcb_amt: b_rcb_amt, b_vst_cnt: b_vst_cnt, live_yn: data['LIVE_YN'], b_crt_amt: b_crt_amt, b_cash_amt: b_cash_amt, b_etc_amt: b_etc_amt, gd_nm: data['GD_NM'] ]
					
			query = "INSERT INTO tb_sales_bill (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
						
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_SALES_BILL Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end

end