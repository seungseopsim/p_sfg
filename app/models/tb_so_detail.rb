class TbSoDetail < ApplicationRecord

	COL = 'h_id, s_id, shop_id, so_dt, so_no, sog_no, b_id, shop_nm, shop_sort, gd_id, sog_jc_st, unit_id, unit_nm, sog_qty, sog_uc, sog_amt, sog_real_amt, sog_vos_amt, sog_tax_amt, sog_taxf_amt, sog_ccl_amt, sog_tax_st, sog_odr_qty, sog_rcv_qty, sog_si_qty, trd_id, trd_nm, gd_nm, live_yn, memo, info, sort_no, cret_usrid, cret_dt, mod_usrid, mod_dt, gdmr_id, gdmj_id, gdmr_nm, gdmj_nm'.freeze
		
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_SO_DETAIL INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_SO_DETAIL RuntimeError #{runtimeerror}"
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
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{so_dt}, %{so_no}, %{sog_no}, '%{b_id}', '%{shop_nm}', %{shop_sort}, '%{gd_id}', '%{sog_jc_st}', '%{unit_id}', '%{unit_nm}', %{sog_qty}, %{sog_uc}, %{sog_amt}, %{sog_real_amt}, %{sog_vos_amt}, %{sog_tax_amt}, %{sog_taxf_amt}, %{sog_ccl_amt}, '%{sog_tax_st}', %{sog_odr_qty}, %{sog_rcv_qty}, %{sog_si_qty}, '%{trd_id}', '%{trd_nm}', '%{gd_nm}', '%{live_yn}', '%{memo}', '%{info}', %{sort_no}, '%{cret_usrid}', %{cret_dt}, '%{mod_usrid}', %{mod_dt}, '%{gdmr_id}', '%{gdmj_id}', '%{gdmr_nm}', '%{gdmj_nm}' " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], so_dt: so_dt, so_no: data['SO_NO'], sog_no: data['SOG_NO'], b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, gd_id: data['GD_ID'], sog_jc_st: data['SOG_JC_ST'], unit_id: data['UNIT_ID'], unit_nm: data['UNIT_NM'], sog_qty: sog_qty, sog_uc: sog_uc, sog_amt: sog_amt, sog_real_amt: sog_real_amt, sog_vos_amt: sog_vos_amt, sog_tax_amt: sog_tax_amt, sog_taxf_amt: sog_taxf_amt, sog_ccl_amt: sog_ccl_amt, sog_tax_st: data['SOG_TAX_ST'], sog_odr_qty: sog_odr_qty, sog_rcv_qty: sog_rcv_qty, sog_si_qty: sog_si_qty, trd_id: data['TRD_ID'], trd_nm: data['TRD_NM'], gd_nm: data['GD_NM'], live_yn: data['LIVE_YN'], memo: data['MEMO'], info: data['INFO'], sort_no: sort_no, cret_usrid: data['CRET_USRID'], cret_dt: cret_dt, mod_usrid: data['MOD_USRID'], mod_dt: mod_dt, gdmr_id: data['GDMR_ID'], gdmj_id: data['GDMJ_ID'], gdmr_nm: data['GDMJ_NM'], gdmj_nm: data['GDMJ_NM'] ]
					
			query = "INSERT INTO tb_so_detail (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)

		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_SO_DETAIL Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end

end