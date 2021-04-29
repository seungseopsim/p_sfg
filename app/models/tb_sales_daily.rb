class TbSalesDaily < ApplicationRecord
	SQLOPTION = " AND s_id != '#{@@CUBE_JJ_ID}' ".freeze
	
	COL = 'h_id, s_id, shop_id, bsn_dt, b_id, ss_sort, shop_sort, shop_nm, sb_amt, sb_rtn_amt, sb_ccl_amt, sb_gd_dst_amt, sb_dst_amt, sb_real_amt, sb_vst_cnt, sb_ord_cnt, sb_vos_amt, sb_tax_amt, sb_taxf_amt, sb_svc_crg_amt, sb_tb_trv_per, sb_rcb_amt, sb_cash_amt, sb_crt_amt, sb_vcr_amt, sb_tick_amt, sb_cs_pnt_amt, sb_oln_amt, sb_mlt_amt, sb_etc_amt, sb_vcr_in_amt, sb_tick_in_amt, sb_etc_in_amt, sb_cash_rct_cnt, sb_cash_rct_amt, sb_ccl_cnt, sb_rtn_cnt, sb_shop_cnt, sb_pkg_cnt, sb_dlr_cnt, sb_epse_amt, sb_trn_dt, cret_dt, sb_to_dt, sb_mod_yn, sb_fm_cash_amt, sb_to_cash_amt, memo'.freeze
	
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_SALES_DAILY INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_SALES_DAILY RuntimeError #{runtimeerror}"
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
			ss_sort = data['SS_SORT'].blank? ? 'NULL' : data['SS_SORT']
			shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
			sb_amt = data['SB_AMT'].blank? ? 'NULL' : data['SB_AMT']
			sb_rtn_amt = data['SB_RTN_AMT'].blank? ? 'NULL' : data['SB_RTN_AMT']
			sb_ccl_amt = data['SB_CCL_AMT'].blank? ? 'NULL' : data['SB_CCL_AMT']
			sb_gd_dst_amt = data['SB_GD_DST_AMT'].blank? ? 'NULL' : data['SB_GD_DST_AMT']
			sb_dst_amt = data['SB_DST_AMT'].blank? ? 'NULL' : data['SB_DST_AMT']
			sb_real_amt = data['SB_REAL_AMT'].blank? ? 'NULL' : data['SB_REAL_AMT']
			sb_vst_cnt = data['SB_VST_CNT'].blank? ? 'NULL' : data['SB_VST_CNT']
			sb_ord_cnt = data['SB_ORD_CNT'].blank? ? 'NULL' : data['SB_ORD_CNT']
			sb_vos_amt = data['SB_VOS_AMT'].blank? ? 'NULL' : data['SB_VOS_AMT']
			sb_tax_amt = data['SB_TAX_AMT'].blank? ? 'NULL' : data['SB_TAX_AMT']
			sb_taxf_amt = data['SB_TAXF_AMT'].blank? ? 'NULL' : data['SB_TAXF_AMT']
			sb_svc_crg_amt = data['SB_SVC_CRG_AMT'].blank? ? 'NULL' : data['SB_SVC_CRG_AMT']
			sb_tb_trv_per = data['SB_TB_TRV_PER'].blank? ? 'NULL' : data['SB_TB_TRV_PER']
			sb_rcb_amt = data['SB_RCB_AMT'].blank? ? 'NULL' : data['SB_RCB_AMT']
			sb_cash_amt = data['SB_CASH_AMT'].blank? ? 'NULL' : data['SB_CASH_AMT']
			sb_crt_amt = data['SB_CRT_AMT'].blank? ? 'NULL' : data['SB_CRT_AMT']
			sb_vcr_amt = data['SB_VCR_AMT'].blank? ? 'NULL' : data['SB_VCR_AMT']
			sb_tick_amt = data['SB_TICK_AMT'].blank? ? 'NULL' : data['SB_TICK_AMT']
			sb_cs_pnt_amt = data['SB_CS_PNT_AMT'].blank? ? 'NULL' : data['SB_CS_PNT_AMT']
			sb_oln_amt = data['SB_OLN_AMT'].blank? ? 'NULL' : data['SB_OLN_AMT']
			sb_mlt_amt = data['SB_MLT_AMT'].blank? ? 'NULL' : data['SB_MLT_AMT']
			sb_etc_amt = data['SB_ETC_AMT'].blank? ? 'NULL' : data['SB_ETC_AMT']
			sb_vcr_in_amt = data['SB_VCR_IN_AMT'].blank? ? 'NULL' : data['SB_VCR_IN_AMT']
			sb_tick_in_amt = data['SB_TICK_IN_AMT'].blank? ? 'NULL' : data['SB_TICK_IN_AMT']
			sb_etc_in_amt = data['SB_ETC_IN_AMT'].blank? ? 'NULL' : data['SB_ETC_IN_AMT']
			sb_cash_rct_cnt = data['SB_CASH_RCT_CNT'].blank? ? 'NULL' : data['SB_CASH_RCT_CNT']
			sb_cash_rct_amt = data['SB_CASH_RCT_AMT'].blank? ? 'NULL' : data['SB_CASH_RCT_AMT']
			sb_ccl_cnt = data['SB_CCL_CNT'].blank? ? 'NULL' : data['SB_CCL_CNT']
			sb_rtn_cnt = data['SB_RTN_CNT'].blank? ? 'NULL' : data['SB_RTN_CNT']
			sb_shop_cnt = data['SB_SHOP_CNT'].blank? ? 'NULL' : data['SB_SHOP_CNT']
			sb_pkg_cnt = data['SB_PKG_CNT'].blank? ? 'NULL' : data['SB_PKG_CNT']
			sb_dlr_cnt = data['SB_DLR_CNT'].blank? ? 'NULL' : data['SB_DLR_CNT']
			sb_epse_amt = data['SB_EPSE_AMT'].blank? ? 'NULL' : data['SB_EPSE_AMT']
			sb_trn_dt = data['SB_TRN_DT'].blank? ? 'NULL' : "'#{data['SB_TRN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			cret_dt = data['CRET_DT'].blank? ? 'NULL' : "'#{data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")}'" 
			sb_to_dt = data['SB_TO_DT'].blank? ? 'NULL' : "'#{data['SB_TO_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
			sb_fm_cash_amt = data['SB_FM_CASH_AMT'].blank? ? 'NULL' : data['SB_FM_CASH_AMT']
			sb_to_cash_amt = data['SB_TO_CASH_AMT'].blank? ? 'NULL' : data['SB_TO_CASH_AMT']	
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, '%{b_id}', %{ss_sort}, %{shop_sort}, '%{shop_nm}', %{sb_amt}, %{sb_rtn_amt}, %{sb_ccl_amt}, %{sb_gd_dst_amt}, %{sb_dst_amt}, %{sb_real_amt}, %{sb_vst_cnt}, %{sb_ord_cnt}, %{sb_vos_amt}, %{sb_tax_amt}, %{sb_taxf_amt}, %{sb_svc_crg_amt}, %{sb_tb_trv_per}, %{sb_rcb_amt}, %{sb_cash_amt}, %{sb_crt_amt}, %{sb_vcr_amt}, %{sb_tick_amt}, %{sb_cs_pnt_amt}, %{sb_oln_amt}, %{sb_mlt_amt}, %{sb_etc_amt}, %{sb_vcr_in_amt}, %{sb_tick_in_amt}, %{sb_etc_in_amt}, %{sb_cash_rct_cnt}, %{sb_cash_rct_amt}, %{sb_ccl_cnt}, %{sb_rtn_cnt}, %{sb_shop_cnt}, '%{sb_pkg_cnt}', %{sb_dlr_cnt}, %{sb_epse_amt}, %{sb_trn_dt}, %{cret_dt}, %{sb_to_dt}, '%{sb_mod_yn}', %{sb_fm_cash_amt}, %{sb_to_cash_amt}, '%{memo}'" % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, b_id: data['B_ID'], ss_sort: ss_sort, shop_sort: shop_sort, shop_nm: data['SHOP_NM'], sb_amt: sb_amt, sb_rtn_amt: sb_rtn_amt, sb_ccl_amt: sb_ccl_amt, sb_gd_dst_amt: sb_gd_dst_amt, sb_dst_amt: sb_dst_amt, sb_real_amt: sb_real_amt, sb_vst_cnt: sb_vst_cnt, sb_ord_cnt: sb_ord_cnt, sb_vos_amt: sb_vos_amt, sb_tax_amt: sb_tax_amt, sb_taxf_amt: sb_taxf_amt, sb_svc_crg_amt: sb_svc_crg_amt, sb_tb_trv_per: sb_tb_trv_per, sb_rcb_amt: sb_rcb_amt, sb_cash_amt: sb_cash_amt, sb_crt_amt: sb_crt_amt, sb_vcr_amt: sb_vcr_amt, sb_tick_amt: sb_tick_amt, sb_cs_pnt_amt: sb_cs_pnt_amt, sb_oln_amt: sb_oln_amt, sb_mlt_amt: sb_mlt_amt, sb_etc_amt: sb_etc_amt, sb_vcr_in_amt: sb_vcr_in_amt, sb_tick_in_amt: sb_tick_in_amt, sb_etc_in_amt: sb_etc_in_amt, sb_cash_rct_cnt: sb_cash_rct_cnt, sb_cash_rct_amt: sb_cash_rct_amt, sb_ccl_cnt: sb_ccl_cnt, sb_rtn_cnt: sb_rtn_cnt, sb_shop_cnt: sb_shop_cnt, sb_pkg_cnt: sb_pkg_cnt, sb_dlr_cnt: sb_dlr_cnt, sb_epse_amt: sb_epse_amt, sb_trn_dt: sb_trn_dt, cret_dt: cret_dt, sb_to_dt: sb_to_dt, sb_mod_yn: data['SB_MOD_YN'], sb_fm_cash_amt: sb_fm_cash_amt, sb_to_cash_amt: sb_to_cash_amt, memo: data['MEMO'] ]
					
			query = "INSERT INTO tb_sales_daily (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
			
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_SALES_DAILY Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end
	
	
	#일별 매출
	def self.sfg_sum(_day)
		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE DATEDIFF(bsn_dt, '%{day}') = 0 %{option}; " % [day: _day, option: SQLOPTION]
		return connection.select_one(query)
		
	end
	
	#일별 매출
	def self.sfg_sum_range_with_beforyear(_start, _end)
		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' %{option} "  % [begin: _start, end: _end, option: SQLOPTION]
		first = connection.select_all(query)
		
		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND DATE_FORMAT(ADDDATE( '%{end}', %{offday}), '%{daytimeformat}' ) %{option}; " % [begin: _start, end: _end, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d", option: SQLOPTION]

		second = connection.select_all(query)
		return calper_shop('SFG', first, second)
	end
	
	#월별 매출 증감
	def self.sfg_sum_rangemonth_with_beforyear(_start, _end)
=begin
		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' %{option} UNION SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(DATE_SUB('%{begin}-01', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{end}-01', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) %{option}; " % [begin: _start, end: _end, offday: 12, dayforamt: "%Y-%m", daytimeformat: "%Y-%m", option: SQLOPTION]
=end
		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{begin}') = 0 %{option}"%  [begin: _start.delete("-"), dayformat: "%Y%m", option: SQLOPTION]
		first = connection.select_all(query)
		
 		query = "SELECT SUM(sb_real_amt) AS total FROM tb_sales_daily WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{end}') = 0 %{option} " % [end: _end.delete("-"), dayformat: "%Y%m", option: SQLOPTION]
		second = connection.select_all(query)


		
		return calper_shop('SFG', first, second)
	end
	
	#일 평균 증감
	def self.sfg_avg_range_with_beforyear(_start, _end)
		query = "SELECT (SUM(sb_real_amt) / (DATEDIFF('%{end}', '%{begin}') + 1)) AS total FROM tb_sales_daily WHERE bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' %{option} UNION SELECT (SUM(sb_real_amt) / (DATEDIFF(DATE_FORMAT(ADDDATE( '%{end}', %{offday}), '%{daytimeformat}' ), DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' )) + 1)) AS total FROM tb_sales_daily WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND DATE_FORMAT(ADDDATE( '%{end}', %{offday}), '%{daytimeformat}' ) %{option}; " % [begin: _start, end: _end, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d", option: SQLOPTION]
	

		queryresult = connection.select_all(query)
		
		return calper(queryresult)		
	end
		
	#월 평균 증감
	def self.sfg_avg_rangemonth_with_beforyear(_start, _end)
=begin
		query = "SELECT AVG(sb_real_amt) AS total FROM tb_sales_daily WHERE bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' %{option} UNION SELECT AVG(sb_real_amt) AS total FROM tb_sales_daily WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND DATE_FORMAT(ADDDATE( '%{end}', %{offday}), '%{daytimeformat}' ) %{option}; " % [begin: _start, end: _end, offday: -364, dayforamt: "%Y-%m", daytimeformat: "%Y-%m", option: SQLOPTION]
=end
		query = "SELECT (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{begin}'), '%{dayformat}')) AS total FROM tb_sales_daily WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{begin2}') = 0 %{option} UNION SELECT (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{end}'), '%{dayformat}')) AS total FROM tb_sales_daily WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{end2}') = 0 %{option} %{option}; " % [begin: "#{_start}-01", end: "#{_end}-01", begin2: _start.delete("-"), end2: _end.delete("-"), dayformat: '%d', yearmonth: "%Y%m", option: SQLOPTION]

		queryresult = connection.select_all(query)
		
		return calper(queryresult)	
	end
	
	#부서 별
	def self.business_sum(_day)
		query = "SELECT idx_shoptotal.s_nm_short AS s_nm_short, idx_shoptotal.s_id AS s_id, sum(tb_sales_daily.sb_real_amt) AS total FROM tb_sales_daily Left JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE s_nm_short is not NULL AND DATEDIFF(bsn_dt, '%{day}') = 0 GROUP BY idx_shoptotal.s_nm_short, idx_shoptotal.s_id ORDER BY idx_shoptotal.s_id ASC;" % [day: _day]
			
		return connection.select_all(query)
	end
	
	def self.business_sum_with_shoplist(_day, _shoplist)
		shops = _shoplist.split(',')
		options = nil
		shops.each do |shop|
			if options.blank?
				options = "tb_sales_daily.shop_id = '#{shop}' "
			else
				options += "OR tb_sales_daily.shop_id = '#{shop}' "
			end
		end
		
		query = "SELECT idx_shoptotal.s_nm_short AS s_nm_short, idx_shoptotal.s_id AS s_id, sum(tb_sales_daily.sb_real_amt) AS total FROM tb_sales_daily Left JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE s_nm_short is not NULL AND DATEDIFF(bsn_dt, '%{day}') = 0 AND %{options} GROUP BY idx_shoptotal.s_nm_short, idx_shoptotal.s_id ORDER BY idx_shoptotal.s_id ASC;" % [day: _day, options: options]
		
		return connection.select_all(query)
	end
	
	def self.business_sum_range_with_beforyear(_start, _end)
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) GROUP BY s_nm_short, s_id" % [begin: _start, end: _end]
		
		first = connection.select_all(query)
		
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') between date_format(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND date_format(ADDDATE('%{end}', %{offday}), '%{daytimeformat}') GROUP BY s_nm_short, s_id;"  % [begin: _start, end: _end, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d"]

		second = connection.select_all(query)

		return calper_shop("s_nm_short", first, second)
	end
	
	def self.business_sum_range_with_beforyear_with_shoplist(_start, _end, _shoplist)
		if(_shoplist.nil?)
			return
		end
				
		options = nil
		_shoplist.each do |info|
			shops = info['s_id'].split(',')
			shops.each do |shop|
				if options.blank?
					options = "idx_shoptotal.s_id = '#{shop}' "
				else
					options += "OR idx_shoptotal.s_id = '#{shop}' "
				end
			end
		end
		
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') between date_format(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND date_format(ADDDATE('%{end}', %{offday}), '%{daytimeformat}') AND %{options} GROUP BY s_nm_short, s_id ORDER BY s_id ASC;"  % [begin: _start, end: _end, options: options, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d %H:%i:%s"]

		queryresult = connection.select_all(query)
		
		return calper(queryresult)
	end
	
	def self.business_sum_rangemonth_with_beforyear(_start, _end)
=begin
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayformat}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') GROUP BY s_nm_short, s_id;"  % [begin: _start, end: _end, beforbegin: "#{_start}-01", beforend: "#{_end}-01", offday: 12, dayformat: "%Y-%m", daytimeformat: "%Y-%m"]
=end
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{begin}') = 0 AND s_nm_short IS NOT NULL GROUP BY s_nm_short, s_id" % [begin: _start.delete("-"), dayformat: "%Y%m"]
		first = connection.select_all(query)
		
 		query ="SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{begin}') = 0 AND s_nm_short IS NOT NULL GROUP BY s_nm_short, s_id" % [begin: _end.delete("-"), dayformat: "%Y%m"]
		
		second = connection.select_all(query)

		return calper_shop('s_nm_short', first, second)
	end
	
		
	def self.business_sum_rangemonth_with_beforyear_with_shoplist(_start, _end, _shoplist)
		if(_shoplist.nil?)
			return
		end
				
		options = nil
		_shoplist.each do |info|
			shops = info['shop_id'].split(',')
			shops.each do |shop|
				if options.blank?
					options = "idx_shoptotal.shop_id = '#{shop}' "
				else
					options += "OR idx_shoptotal.shop_id = '#{shop}' "
				end
			end
		end
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND (%{options}) GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, SUM(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') AND (%{options}) GROUP BY s_nm_short, s_id ORDER BY s_nm_short ASC;"  % [begin: _start, end: _end, beforbegin: "#{_start}-01", beforend: "#{_end}-01", options: options, offday: 12, dayforamt: "%Y-%m", daytimeformat: "%Y-%m"]

		queryresult = connection.select_all(query)
		
		return calper(queryresult)
	end

	def self.business_avg_range_with_beforyear(_start, _end)
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, (SUM(sb_real_amt)/ (DATEDIFF('%{end}', '%{begin}') + 1)) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) GROUP BY s_nm_short, s_id; " % [begin: _start, end: _end]
		first = connection.select_all(query)
		
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, (SUM(sb_real_amt) / (DATEDIFF( DATE_FORMAT(ADDDATE('%{end}', %{offday}), '%{dayformat}'), DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{dayformat}' )) + 1)) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayformat}') between DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{dayformat}' ) AND DATE_FORMAT(ADDDATE('%{end}', %{offday}), '%{dayformat}') GROUP BY s_nm_short, s_id;"  % [begin: _start, end: _end, offday: -364, dayformat: "%Y-%m-%d"]
			
		second = connection.select_all(query)

		return calper_shop("s_nm_short", first, second)	
	end
	
	def self.business_avg_range_with_beforyear_with_shoplist(_start, _end, _shoplist)
		if(_shoplist.nil?)
			return
		end
				
		options = nil
		_shoplist.each do |info|
			shops = info['s_id'].split(',')
			shops.each do |shop|
				if options.blank?
					options = "idx_shoptotal.s_id = '#{shop}' "
				else
					options += "OR idx_shoptotal.s_id = '#{shop}' "
				end
			end
		end
		
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') between date_format(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}' ) AND date_format(ADDDATE('%{end}', %{offday}), '%{daytimeformat}') AND %{options} GROUP BY s_nm_short, s_id;"  % [begin: _start, end: _end, options: options, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d %H:%i:%s"]

		queryresult = connection.select_all(query)
		
		return calper(queryresult)	
	end
	
	def self.business_avg_rangemonth_with_beforyear(_start, _end)
=begin
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayformat}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') GROUP BY s_nm_short, s_id;"  % [begin: _start, end: _end, beforbegin: "#{_start}-01", beforend: "#{_end}-01", offday: 12, dayformat: "%Y-%m", daytimeformat: "%Y-%m"]
=end
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{begin}'), '%{dayforamt}')) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{begin2}') = 0 GROUP BY s_nm_short, s_id;" % [begin: "#{_start}-01", begin2: _start.delete("-"), dayforamt: '%d', yearmonth: "%Y%m"]
		first = connection.select_all(query)

		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{begin}'), '%{dayforamt}')) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{begin2}') = 0 GROUP BY s_nm_short, s_id;" % [begin: "#{_end}-01", begin2: _end.delete("-"), dayforamt: '%d', yearmonth: "%Y%m"]
		second = connection.select_all(query)
		
		return calper_shop('s_nm_short', first, second)	
	end
	
	def self.business_avg_rangemonth_with_beforyear_with_shoplist(_start, _end, _shoplist)
		if(_shoplist.nil?)
			return
		end
				
		options = nil
		_shoplist.each do |info|
			shops = info['s_id'].split(',')
			shops.each do |shop|
				if options.blank?
					options = "idx_shoptotal.s_id = '#{shop}' "
				else
					options += "OR idx_shoptotal.s_id = '#{shop}' "
				end
			end
		end
		
		query = "SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND (%{options}) GROUP BY s_nm_short, s_id UNION SELECT s_nm_short, idx_shoptotal.s_id AS s_id, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') AND (%{options}) GROUP BY s_nm_short, s_id ORDER BY s_id ASC;"  % [begin: _start, end: _end, beforbegin: "#{_start}-01", beforend: "#{_end}-01", options: options, offday: 12, dayforamt: "%Y-%m", daytimeformat: "%Y-%m"]
		
		queryresult = connection.select_all(query)
		
		return calper(queryresult)	
	end
	
	#가게 별
	
	def self.shop_sum(_type, _id, _day)
		options = nil
		if _type == 1
			options = "s_id = '%{id}' " % [id: _id]
		else
			options = "shop_id = '%{id}' "  % [id: _id]
		end
		
		query = "SELECT shop_id, shop_nm, s_id, shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily WHERE %{options} AND DATEDIFF(bsn_dt, '%{day}') = 0 GROUP BY shop_id, shop_nm, s_id, shop_sort ORDER BY shop_sort ASC;" % [options: options, day: _day]
		
		return connection.select_all(query)	
	end
	
	
	def self.shop_sum_range_with_beforyear(_type, _id, _start, _end)
		options = nil
		id = _id
		if _type == 1
			if id == @@SH_JJ_ID
				id = @@CUBE_JJ_ID
			end
			options = "tb_sales_daily.s_id = '#{id}'"
		else
			options = "tb_sales_daily.shop_id = '#{id}'"
		end
				
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options]
		first = connection.select_all(query)

		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN date_format(ADDDATE('%{begin}', %{offday}), '%{daytimeformat}') AND date_format(ADDDATE('%{end}', %{offday}), '%{daytimeformat}') AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options, offday: -364, dayforamt: "%Y-%m-%d", daytimeformat: "%Y-%m-%d"]

		second = connection.select_all(query)

		return calper_shop("shop_nm", first, second)
	end
	
	def self.shop_sum_rangemonth_with_beforyear(_type, _id, _start, _end)
		options = nil
		id = _id
		if _type == 1
			if id == @@SH_JJ_ID
				id = @@CUBE_JJ_ID
			end
			options = "tb_sales_daily.s_id = '#{id}'"
		else
			options = "tb_sales_daily.shop_id = '#{id}'"
		end
=begin
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort UNION SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayforamt}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options, beforbegin: "#{_start}-01", beforend: "#{_end}-01", offday: 12, dayforamt: "%Y-%m", daytimeformat: "%Y-%m"]
=end
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{begin}') = 0 AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start.delete("-"), options: options, dayformat: "%Y%m" ]
		
		first = connection.select_all(query)

		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, sum(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{dayformat}'), '%{begin}') = 0 AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _end.delete("-"), options: options, dayformat: "%Y%m" ]
		
		second = connection.select_all(query)
			
		return calper_shop('shop_nm', first, second )
	end
	
	def self.shop_avg_range_with_beforyear(_type, _id, _start, _end)
		options = nil
		id = _id
		if _type == 1
			if id == @@SH_JJ_ID
				id = @@CUBE_JJ_ID
			end
			options = "tb_sales_daily.s_id = '#{id}'"
		else
			options = "tb_sales_daily.shop_id = '#{id}'"
		end
		
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, (SUM(sb_real_amt) / (DATEDIFF('%{end}', '%{begin}') + 1)) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options]
		first = connection.select_all(query)

		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, (SUM(sb_real_amt) / (DATEDIFF(DATE_FORMAT(ADDDATE('%{end}', %{offday}), '%{dayformat}'), DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{dayformat}')) + 1)) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayformat}') BETWEEN DATE_FORMAT(ADDDATE('%{begin}', %{offday}), '%{dayformat}') AND DATE_FORMAT(ADDDATE('%{end}', %{offday}), '%{dayformat}') AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options, offday: -364, dayformat: "%Y-%m-%d"]
		
		second = connection.select_all(query)
		
		return calper_shop('shop_nm', first, second)
	end
	
	def self.shop_avg_rangemonth_with_beforyear(_type, _id, _start, _end)
		options = nil
		id = _id
		if _type == 1
			if id == @@SH_JJ_ID
				id = @@CUBE_JJ_ID
			end
			options = "tb_sales_daily.s_id = '#{id}'"
		else
			options = "tb_sales_daily.shop_id = '#{id}'"
		end
=begin
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm, tb_sales_daily.shop_sort, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE (bsn_dt >= '%{begin}' AND bsn_dt <= '%{end}' ) AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort UNION SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm, tb_sales_daily.shop_sort, AVG(sb_real_amt) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE DATE_FORMAT(bsn_dt, '%{dayformat}') BETWEEN DATE_FORMAT(DATE_SUB('%{beforbegin}', INTERVAL %{offday} MONTH), '%{daytimeformat}' ) AND DATE_FORMAT(DATE_SUB('%{beforend}', INTERVAL %{offday} MONTH), '%{daytimeformat}') AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort ORDER by shop_sort ASC;" % [begin: _start, end: _end, options: options, beforbegin: "#{_start}-01", beforend: "#{_end}-01", offday: 12, dayformat: "%Y-%m", daytimeformat: "%Y-%m"]
queryresult = connection.select_all(query)
=end
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{begin}'), '%{dayformat}')) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{begin2}') = 0 AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort;" % [begin: "#{_start}-01", begin2: _start.delete("-"), options: options, dayformat: '%d', yearmonth: "%Y%m"]
		first = connection.select_all(query)
		
		query = "SELECT tb_sales_daily.shop_id, tb_sales_daily.shop_nm AS shop_nm, tb_sales_daily.shop_sort, (SUM(sb_real_amt) / DATE_FORMAT(LAST_DAY('%{begin}'), '%{dayformat}')) AS total FROM tb_sales_daily LEFT JOIN idx_shoptotal ON idx_shoptotal.shop_id = tb_sales_daily.shop_id WHERE PERIOD_DIFF(DATE_FORMAT(bsn_dt, '%{yearmonth}'), '%{begin2}') = 0 AND %{options} GROUP BY tb_sales_daily.shop_id, shop_nm, shop_sort;" % [begin: "#{_end}-01", begin2: _end.delete("-"), options: options, dayformat: '%d', yearmonth: "%Y%m"]
		second = connection.select_all(query)
		
		return calper_shop('shop_nm', first, second)
	end
	
	
	def self.latelysales

		
		query = "SELECT BSN_DT as date, SUBSTR( _UTF8'일월화수목금토', DAYOFWEEK( bsn_dt ), 1 ) AS wk, sum(SB_REAL_AMT) As sales
from tb_sales_daily 
where shop_nm not like '%자작%'
group by BSN_DT 
order by BSN_DT desc
limit 0,10 ;"
		
		return connection.select_all(query)
	end
	
	private
		
	def self.calper(_result)
		result = _result
		
		if result.blank?
			return result
		end
		
		result.each_slice(2) do |temp|
			if temp.length > 1
				if( temp[0]['total'].blank? || temp[1]['total'].blank? )
					temp[1]['per'] = 0.0
				else
					sub = temp[0]['total'] - temp[1]['total']
					if(temp[0]['total'] <= 0.0)
						temp[1]['per'] = 100.0
					else
						temp[1]['per'] = ((sub / temp[1]['total']) * 100).round(1)
					end
				end
			else 
				temp[0]['per'] = 0.0
			end
		end
		
		return result
	end
		
	def self.calper_business(_key, _first, _second)		
			
		if _first.blank? && _second.blank?
			return nil
		end
		
		result = Hash.new
		
		
		if _first.present? && _second.blank?
			_first.each do |info|
				result[info[_key]] = { first: info['total'], second: "", per: "" }
			end
		elsif _first.blank? && _second.present?
			_second.each do |info|
				result[info[_key]] = { first: "", second: info['total'], per: "" }
			end
		elsif _first.present? && _second.present?
			_first.each do |info|
				find = _second.lazy.select{ |value| value[_key] == info[_key] }
				if find.present?
					first = info['total']
					second = find[0]['total']
					per = 0.0
					if(first <= 0.0)
						sub = 100.0
					else
						sub = first - second
						per = ((sub / second) * 100).round(1)
					end

					result[info[_key]] = { first: first, second: second, per: per }
				end
			end
		end
		
		return result
	end
	
		
	def self.calper_shop(_key, _first, _second)		
			
		if _first.blank? && _second.blank?
			return nil
		end
		
		result = Hash.new
		
		if _first.present?
			_first.each do |info|
				result[info[_key]] = { first: info['total'], s_id: info['s_id'], per: "" }
			end
		end
		
		if _second.present?
			_second.each do |info|
				key = info[_key]
				if result.key?(key)
					first = result[key][:first]
					second = info['total']
					per = 0.0
					if(first.blank? || second.blank?)
						per = 100.0
					else
						sub = first - second
						per = ((sub / second) * 100).round(1)
					end
					
					result[key][:second] = second
					result[key][:per] = per
				else
					result[key] = { second: info['total'], s_id: info['s_id'], per: "" }
				end
			end
		end	
		
		return result.lazy.sort_by{ |key, value| value[:s_id] }
	end
	
	
end
