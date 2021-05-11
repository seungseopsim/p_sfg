class TbCosDaily < ApplicationRecord
			
	COL = "h_id, s_id, shop_id, bsn_dt, b_id, shop_nm, shop_sort, sbg_real_amt, sb_avg_amt, sog_real_amt, sog_rate".freeze
	TABLE = "tb_cos_daily".freeze

	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
	
		cubedata = Cubedb::VShCosDaliy.selectall(_day)
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

		bsn_dt = data['BSN_DT'].blank? ? 'NULL' : "'#{data['BSN_DT'].strftime("%Y-%m-%d %H:%M:%S")}'"
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		sbg_real_amt = data['SBG_REAL_AMT'].blank? ? 'NULL' : data['SBG_REAL_AMT']
		sb_avg_amt = data['SB_AVG_AMT'].blank? ? 'NULL' : data['SB_AVG_AMT']
		sog_real_amt = data['SOG_REAL_AMT'].blank? ? 'NULL' : data['SOG_REAL_AMT']
		sog_rate = data['SOG_RATE'].blank? ? 'NULL' : data['SOG_RATE']

		value = " '%{h_id}', '%{s_id}', '%{shop_id}', %{bsn_dt}, '%{b_id}', \"%{shop_nm}\", %{shop_sort}, %{sbg_real_amt}, %{sb_avg_amt}, %{sog_real_amt}, %{sog_rate} " % 
		[ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], bsn_dt: bsn_dt, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, sbg_real_amt: sbg_real_amt, sb_avg_amt: sb_avg_amt, sog_real_amt: sog_real_amt, sog_rate: sog_rate ]

		return "%{val}" % [val: value]
	end
end