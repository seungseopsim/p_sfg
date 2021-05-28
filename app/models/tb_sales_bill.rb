class TbSalesBill < ApplicationRecord

	COL = 'h_id, s_id, shop_id, bsn_dt, bsn_no, b_id, shop_nm, shop_sort, stb_id, b_odr_dt, b_crg_dt, b_odr_st, b_st, b_ccl_amt, b_dst_amt, b_rcb_amt, b_vst_cnt, live_yn, b_crt_amt, b_cash_amt, b_etc_amt, gd_nm'.freeze
	TABLE = "tb_sales_bill".freeze
	@@insertThread = nil
    #@@semaphore = Mutex.new

	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		cubedata = Cubedb::VShSalesBill.selectall(_day)
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
			puts "#{TABLE}-#{_day} Insert Error #{exception}"
			cnt = -1
			raise ActiveRecord::Rollback
		ensure
            query = nil
		end

		return cnt
	end
	
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
		bsn_no = connection.quote(data['BSN_NO'])
		b_id = connection.quote(data['B_ID'])
		shop_nm = connection.quote(data['SHOP_NM'])
		shop_sort = connection.quote(data['SHOP_SORT'])
		stb_id =connection.quote(data['STB_ID'])
		b_odr_dt = data['B_ODR_DT'].blank? ? nil : data['B_ODR_DT'].strftime("%Y-%m-%d %H:%M:%S")
		b_odr_dt = connection.quote(b_odr_dt)
		b_crg_dt = data['B_CRG_DT'].blank? ? nil : data['B_CRG_DT'].strftime("%Y-%m-%d %H:%M:%S")
		b_crg_dt = connection.quote(b_crg_dt)
		b_odr_st = connection.quote(data['B_ODR_ST'])
		b_st = connection.quote(data['B_ST'])
		b_ccl_amt = connection.quote(data['B_CCL_AMT'])
		b_dst_amt = connection.quote(data['B_DST_AMT'])
		b_rcb_amt = connection.quote(data['B_RCB_AMT'])
		b_vst_cnt = connection.quote(data['B_VST_CNT'])
		live_yn = connection.quote(data['LIVE_YN'])
		b_crt_amt = connection.quote(data['B_CRT_AMT'])
		b_cash_amt = connection.quote(data['B_CASH_AMT'])
		b_etc_amt = connection.quote(data['B_ETC_AMT'])
		gd_nm = connection.quote(data['GD_NM'])
			
		value = "#{h_id}, #{s_id}, #{shop_id}, #{bsn_dt}, #{bsn_no}, #{b_id}, #{shop_nm}, #{shop_sort}, #{stb_id}, #{b_odr_dt}, #{b_crg_dt}, #{b_odr_st}, #{b_st}, #{b_ccl_amt}, #{b_dst_amt}, #{b_rcb_amt}, #{b_vst_cnt}, #{live_yn}, #{b_crt_amt}, #{b_cash_amt}, #{b_etc_amt}, #{gd_nm}"

		return "%{val}" % [val: value]
	end

end