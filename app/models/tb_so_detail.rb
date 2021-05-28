class TbSoDetail < ApplicationRecord

	COL = 'h_id, s_id, shop_id, so_dt, so_no, sog_no, b_id, shop_nm, shop_sort, gd_id, sog_jc_st, unit_id, unit_nm, sog_qty, sog_uc, sog_amt, sog_real_amt, sog_vos_amt, sog_tax_amt, sog_taxf_amt, sog_ccl_amt, sog_tax_st, sog_odr_qty, sog_rcv_qty, sog_si_qty, trd_id, trd_nm, gd_nm, live_yn, memo, info, sort_no, cret_usrid, cret_dt, mod_usrid, mod_dt, gdmr_id, gdmj_id, gdmr_nm, gdmj_nm'.freeze
    TABLE = "tb_so_detail".freeze
    
    @@insertThread = nil
    #@@semaphore = Mutex.new
	
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
        cubedata = Cubedb::VShSoDetail.selectall(_day)
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
                        #Rails.logger.info result
                        puts result
                        @@insertThread = nil
					end
                end
            rescue => runtimeerror
                result = "#{TABLE}-#{_day} RuntimeError #{runtimeerror}"
                #Rails.logger.error result
                @@insertThread = nil
			ensure
				puts result
            end
        else
            result = "#{TABLE}-#{_day} INSERTING....#{@@insertThread.status}"
        end
        
		return result
	end
	
	private
	
	private_class_method def self.insertdata(_day, _datas)
		cnt = 0
				
		if _datas.blank?
            #Rails.logger.info "#{TABLE}-#{_day} CUBE DATA CNT #{cnt}"
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
		rescue ActiveRecord::ActiveRecordError => exception
			#Rails.logger.error "#{TABLE}-#{_day} Insert Error #{exception}"
            cnt = -1
            puts  "#{TABLE}-#{_day} Insert Error #{exception}"
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
			query = "DELETE FROM %{table} WHERE so_dt = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
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
		so_dt = data['SO_DT'].blank? ? nil : data['SO_DT'].strftime("%Y-%m-%d %H:%M:%S")
		so_dt = connection.quote(so_dt)	
		so_no = connection.quote(data['SO_NO'])
		sog_no = connection.quote(data['SOG_NO'])
		b_id = connection.quote(data['B_ID'])
		shop_nm =  connection.quote(data['SHOP_NM'])
		shop_sort =  connection.quote(data['SHOP_SORT'])
		unit_nm =  connection.quote(data['UNIT_NM'])
		gd_id = connection.quote(data['GD_ID'])
		sog_jc_st = connection.quote(data['SOG_JC_ST'])
		unit_id = connection.quote(data['UNIT_ID'])
		unit_nm = connection.quote(data['UNIT_NM'])
		sog_qty =  connection.quote(data['SOG_QTY'])
		sog_uc = connection.quote(data['SOG_UC'])
		sog_amt = connection.quote(data['SOG_AMT'])
		sog_real_amt = connection.quote(data['SOG_REAL_AMT'])
		sog_vos_amt = connection.quote(data['SOG_VOS_AMT'])
		sog_tax_amt = connection.quote(data['SOG_TAX_AMT'])
		sog_taxf_amt = connection.quote(data['SOG_TAXF_AMT'])
		sog_ccl_amt = connection.quote(data['SOG_CCL_AMT'])
		sog_tax_st = connection.quote(data['SOG_TAX_ST'])
		sog_odr_qty = connection.quote(data['SOG_ODR_QTY'])
		sog_rcv_qty = connection.quote(data['SOG_RCV_QTY'])
		sog_si_qty = connection.quote(data['SOG_SI_QTY'])
		trd_id = connection.quote(data['TRD_ID'])
		trd_nm = connection.quote(data['TRD_NM'])
		gd_nm = connection.quote(data['GD_NM'])
		live_yn = connection.quote(data['LIVE_YN'])
		memo = connection.quote(data['MEMO'])
		info = connection.quote(data['INFO'])
		sort_no = connection.quote(data['SORT_NO'])
		cret_usrid = connection.quote(data['CRET_USRID'])
		cret_dt = data['CRET_DT'].blank? ? nil : data['CRET_DT'].strftime("%Y-%m-%d %H:%M:%S")
	    cret_dt = connection.quote(cret_dt)
		mod_usrid = connection.quote(data['MOD_USRID'])
		mod_dt = data['MOD_DT'].blank? ? nil : data['MOD_DT'].strftime("%Y-%m-%d %H:%M:%S")
		mod_dt = connection.quote(mod_dt)
		gdmr_id = connection.quote(data['GDMR_ID'])
		gdmj_id = connection.quote(data['GDMJ_ID'])
		gdmr_nm = connection.quote(data['GDMR_NM'])
		gdmj_nm = connection.quote(data['GDMJ_NM'])

		
		value = "#{h_id}, #{s_id}, #{shop_id}, #{so_dt}, #{so_no}, #{sog_no}, #{b_id}, #{shop_nm}, #{shop_sort}, #{gd_id}, #{sog_jc_st}, #{unit_id}, #{unit_nm}, #{sog_qty}, #{sog_uc}, #{sog_amt}, #{sog_real_amt}, #{sog_vos_amt}, #{sog_tax_amt}, #{sog_taxf_amt}, #{sog_ccl_amt}, #{sog_tax_st}, #{sog_odr_qty}, #{sog_rcv_qty}, #{sog_si_qty}, #{trd_id}, #{trd_nm}, #{gd_nm}, #{live_yn}, #{memo}, #{info}, #{sort_no}, #{cret_usrid}, #{cret_dt}, #{mod_usrid}, #{mod_dt}, #{gdmr_id}, #{gdmj_id}, #{gdmr_nm}, #{gdmj_nm}" 

		return "%{val}" % [val: value]
	end
end