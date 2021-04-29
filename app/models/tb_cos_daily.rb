class TbCosDaily < ApplicationRecord
			
	COL = "h_id, s_id, shop_id, bsn_dt, b_id, shop_nm, shop_sort, sbg_real_amt, sb_avg_amt, sog_real_amt, sog_rate".freeze
	
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					logger.info "TB_COS_DAILY INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			logger.error "TB_COS_DAILY RuntimeError #{runtimeerror}"
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
			shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
			sbg_real_amt = data['SBG_REAL_AMT'].blank? ? 'NULL' : data['SBG_REAL_AMT']
			sb_avg_amt = data['SB_AVG_AMT'].blank? ? 'NULL' : data['SB_AVG_AMT']
			sog_real_amt = data['SOG_REAL_AMT'].blank? ? 'NULL' : data['SOG_REAL_AMT']
			sog_rate = data['SOG_RATE'].blank? ? 'NULL' : data['SOG_RATE']
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, '%{b_id}', '%{shop_nm}', %{shop_sort}, %{sbg_real_amt}, %{sb_avg_amt}, %{sog_real_amt}, %{sog_rate} " % 
			[ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, sbg_real_amt: sbg_real_amt, sb_avg_amt: sb_avg_amt, sog_real_amt: sog_real_amt, sog_rate: sog_rate ]
			
			query = "INSERT INTO tb_cos_daily (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
			
		rescue ActiveRecord::ActiveRecordError => exception
			logger.error "TB_COS_DAILY Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		return cnt
	end
	
end