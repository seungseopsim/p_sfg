class TbInvt < ApplicationRecord

	COL = 'h_id, s_id, shop_id, gd_id, so_date, b_id, shop_nm, shop_sort, gd_nm, unit_id, min_qty, max_qty, bsn_qty, prs_qty, srate, real_qty, real_amt, so_qty, so_amt'.freeze
		
	@@insertThread = nil
	
	def self.insert(_datas)

		if( @@insertThread != nil)
			return 'Working'
		end
		
		begin
			@@insertThread = Thread.new do
				Rails.application.executor.wrap do
					insertdata = insertdata(_datas)
					Rails.logger.info "TB_INVT INSERT DATA CNT #{insertdata}"
					@@insertThread = nil
				end
			end
		rescue RuntimeError => runtimeerror
			Rails.logger.error "TB_INVT RuntimeError #{runtimeerror}"
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
			Rails.logger.info "TB_INVT CUBE DATA CNT #{cnt}"
			return cnt
		end	
		
		_datas.each do |data|
		begin
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
			
			value = " '%{h_id}', '%{s_id}', '%{shop_id}', '%{gd_id}', %{so_date}, '%{b_id}', '%{shop_nm}', %{shop_sort}, '%{gd_nm}', '%{unit_id}', %{min_qty}, %{max_qty}, %{bsn_qty}, %{prs_qty}, %{srate}, %{real_qty}, %{real_amt}, %{so_qty}, %{so_amt} " % [ h_id: data['H_ID'], s_id: data['S_ID'], shop_id: data['SHOP_ID'], gd_id: data['GD_ID'], so_date: so_date, b_id: data['B_ID'], shop_nm: data['SHOP_NM'], shop_sort: shop_sort, gd_nm: data['GD_NM'], unit_id: data['UNIT_ID'], min_qty: min_qty, max_qty: max_qty, bsn_qty: bsn_qty, prs_qty: prs_qty, srate: srate, real_qty: real_qty, real_amt: real_amt, so_qty: so_qty, so_amt: so_amt ]
					
			query = "INSERT INTO tb_invt (%{col}) VALUES( %{val} ); " % [col: COL, val: value ]
			result = connection.execute(query)
		rescue ActiveRecord::RecordNotUnique
			next		
		rescue ActiveRecord::ActiveRecordError => exception
			Rails.logger.error "TB_INVT Insert Error #{exception}"
			next
		end
			cnt += 1
		end	
	
		Rails.logger.info "TB_INVT CUBE DATA CNT #{_datas.length} : Insert #{cnt}"
		return cnt
	end

end