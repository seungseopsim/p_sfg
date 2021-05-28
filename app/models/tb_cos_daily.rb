class TbCosDaily < ApplicationRecord
			
	COL = "h_id, s_id, shop_id, bsn_dt, b_id, shop_nm, shop_sort, sbg_real_amt, sb_avg_amt, sog_real_amt, sog_rate".freeze
	TABLE = "tb_cos_daily".freeze
    
    @@insertThread = nil

	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
	
		cubedata = Cubedb::VShCosDaliy.selectall(_day)
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
			#Rails.logger.error "#{TABLE}-#{_day} Insert Error #{exception}"
			puts "#{TABLE}-#{_day} Insert Error #{exception}"
			cnt = -1
			raise ActiveRecord::Rollback
		ensure
            query = nil
            #Rails.logger.flush
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
		b_id = connection.quote(data['B_ID'])
		shop_nm = connection.quote(data['SHOP_NM'])
		shop_sort = connection.quote(data['SHOP_SORT'])
		sbg_real_amt = connection.quote(data['SBG_REAL_AMT'])
		sb_avg_amt = connection.quote(data['SB_AVG_AMT'])
		sog_real_amt = connection.quote(data['SOG_REAL_AMT'])
		sog_rate = connection.quote(data['SOG_RATE'])

		value = "#{h_id}, #{s_id}, #{shop_id}, #{bsn_dt}, #{b_id}, #{shop_nm}, #{shop_sort}, #{sbg_real_amt}, #{sb_avg_amt}, #{sog_real_amt}, #{sog_rate}" 
		return "%{val}" % [val: value]
	end
end