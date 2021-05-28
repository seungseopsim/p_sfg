class TbInvt < ApplicationRecord

	COL = 'h_id, s_id, shop_id, gd_id, so_date, b_id, shop_nm, shop_sort, gd_nm, unit_id, min_qty, max_qty, bsn_qty, prs_qty, srate, real_qty, real_amt, so_qty, so_amt'.freeze
	TABLE = "tb_invt".freeze
	@@insertThread = nil
    #@@semaphore = Mutex.new
    
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShInvt.selectall(_day)
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
				#Rails.logger.error "#{TABLE}-#{_day} RuntimeError #{runtimeerror}"
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
			query = "DELETE FROM %{table} WHERE so_date = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
			cnt = connection.exec_delete(query)
			#Rails.logger.info "#{TABLE}-#{_day} deletedata #{cnt}"
			log = "#{TABLE}-#{_day} deletedata #{cnt}"
		rescue ActiveRecord::ActiveRecordError => exception
			#Rails.logger.error "#{TABLE}-#{_day} deletedata Error #{exception}"
			log = "#{TABLE}-#{_day} deletedata Error #{exception}"
			result = false
            raise ActiveRecord::Rollback
        ensure
            #Rails.logger.flush
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
		gd_id = connection.quote(data['GD_ID'])
		so_date = data['SO_DATE'].blank? ? nil : data['SO_DATE'].strftime("%Y-%m-%d %H:%M:%S")
		so_date = connection.quote(so_date)
		b_id = connection.quote(data['B_ID'])
		shop_nm = connection.quote(data['SHOP_NM'])
		shop_sort = connection.quote(data['SHOP_SORT'])
		gd_nm = connection.quote(data['GD_NM'])
		unit_id = connection.quote(data['UNIT_ID'])
		min_qty = connection.quote(data['MIN_QTY'])
		max_qty = connection.quote(data['MAX_QTY'])
		bsn_qty = connection.quote(data['BSN_QTY'])
		prs_qty = connection.quote(data['PRS_QTY'])
		srate = connection.quote(data['SRATE'])
		real_qty = connection.quote(data['REAL_QTY'])
		real_amt = connection.quote(data['REAL_AMT'])
		so_qty = connection.quote(data['SO_QTY'])
		so_amt = connection.quote(data['SO_AMT'])

		value = "#{h_id}, #{s_id}, #{shop_id}, #{gd_id}, #{so_date}, #{b_id}, #{shop_nm}, #{shop_sort}, #{gd_nm}, #{unit_id}, #{min_qty}, #{max_qty}, #{bsn_qty}, #{prs_qty}, #{srate}, #{real_qty}, #{real_amt}, #{so_qty}, #{so_amt}"
		return "%{val}" % [val: value]
	end
end