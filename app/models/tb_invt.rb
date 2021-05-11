class TbInvt < ApplicationRecord

	COL = 'h_id, s_id, shop_id, gd_id, so_date, b_id, shop_nm, shop_sort, gd_nm, unit_id, min_qty, max_qty, bsn_qty, prs_qty, srate, real_qty, real_amt, so_qty, so_amt'.freeze
	TABLE = "tb_invt".freeze
	@@insertThread = nil
	
	def self.insert(_day)
		result = "#{TABLE}-#{_day} : INSERT NO DATA"
		
		cubedata = Cubedb::VShInvt.selectall(_day)
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
			query = "DELETE FROM %{table} WHERE so_date = '%{bsn_dt}' " % [table: TABLE, bsn_dt: _day]
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
		
		so_date = data['SO_DATE'].blank? ? 'NULL' : "'#{data['SO_DATE'].strftime("%Y-%m-%d %H:%M:%S")}'"
		shop_sort = data['SHOP_SORT'].blank? ? 'NULL' : data['SHOP_SORT']
		min_qty = data['MIN_QTY'].blank? ? 'NULL' : data['MIN_QTY']
		max_qty = data['MAX_QTY'].blank? ? 'NULL' : data['MAX_QTY']
		bsn_qty = data['BSN_QTY'].blank? ? 'NULL' : data['BSN_QTY']
		prs_qty = data['PRS_QTY'].blank? ? 'NULL' : data['PRS_QTY']
		srate = data['SRATE'].blank? ? 'NULL' : data['SRATE']
		real_qty = data['REAL_QTY'].blank? ? 'NULL' : data['REAL_QTY']
		real_amt = data['REAL_AMT'].blank? ? 'NULL' : data['REAL_AMT']
		so_qty = data['SO_QTY'].blank? ? 'NULL' : data['SO_QTY']
		so_amt = data['SO_AMT'].blank? ? 'NULL' : data['SO_AMT']

		value = " '%{h_id}', '%{s_id}', '%{shop_id}', '%{gd_id}', %{so_date}, '%{b_id}', \"%{shop_nm}\", %{shop_sort}, \"%{gd_nm}\", '%{unit_id}', %{min_qty}, %{max_qty}, %{bsn_qty}, %{prs_qty}, %{srate}, %{real_qty}, %{real_amt}, %{so_qty}, %{so_amt} " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], gd_id: data['GD_ID'], so_date: so_date, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, gd_nm: data['GD_NM'], unit_id: data['UNIT_ID'], min_qty: min_qty, max_qty: max_qty, bsn_qty: bsn_qty, prs_qty: prs_qty, srate: srate, real_qty: real_qty, real_amt: real_amt, so_qty: so_qty, so_amt: so_amt ]

		return "%{val}" % [val: value]
	end
end