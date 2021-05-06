class LinkController < ApplicationController
	# 연동 처리	
	protect_from_forgery unless:  -> { request.format.json? }, only: [:setting]
	
	def idxinvt
		cubedata = Cubedb::VShIdxInvt.selectall
		data = IdxInvt.insert(cubedata)
		render json: "IDX_INVT CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	def idxshop
		cubedata = Cubedb::VShIdxShop.selectall
		data = IdxShop.insert(cubedata)
		render json: "IDX_SHOP CUBE DATA CNT #{cubedata.length} : #{data}"
	end	
	
	#일별 식자재비율	
	def cos_daily
		day = day_param
		cubedata = Cubedb::VShCosDaliy.selectall(day)
		data = TbCosDaily.insert(cubedata)
		render json: "COS_DAILY CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	#일별 마감매출
	def sales_daily
		day = day_param
		cubedata = Cubedb::VShSalesDaily.selectall(day)
		#render json: cubedata
		data = TbSalesDaily.insert(cubedata)
		render json: "SALES_DAILY CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	#메뉴별 판매현황
	def sales_detail
		day = day_param
		cubedata = Cubedb::VShSalesDetail.selectall(day)
	    data = TbSalesDetail.insert(cubedata)
		#render json: cubedata.length
		render json: "SALES_DETAIL CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	#빌 단위 판매현황
	def sales_bill
		day = day_param
		cubedata = Cubedb::VShSalesBill.selectall(day)
		data = TbSalesBill.insert(cubedata)
		#render json: cubedata
		render json: "SALES_BILL CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	# 사업현황
	def so_detail
		day = day_param
		cubedata = Cubedb::VShSoDetail.selectall(day)
		data = TbSoDetail.insert(cubedata)
		render json: "SO_DETAIL CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	#선불카드 사용현황
	def ppc_use
		day = day_param
		cubedata = Cubedb::VShPpcUse.selectall(day)
		data = TbPpcUse.insert(cubedata)
		#render json: cubedata
		render json: "PPC_USE CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	# 선불카드 적립현황
	def ppc_save
		day = day_param
		cubedata = Cubedb::VShPpcSave.selectall(day)
		data = TbPpcSave.insert(cubedata)
		#render json: cubedata
		render json: "PPC_SAVE CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	# 주요 식자재 재고현황 및 수율
	def tbinvt
		day = day_param
		cubedata = Cubedb::VShInvt.selectall(day)
		data = TbInvt.insert(cubedata)
		#render json: cubedata
		render json: "TB_INVT CUBE DATA CNT #{cubedata.length} : #{data}"
	end
	
	def setting
	
		result = false

		begin
			vaildparam = appsetting_params
			
			tokenparam = vaildparam[:token]
			msgtoken = vaildparam[:msgtoken]
			
			token = remember_token_decrypt_and_verify(tokenparam)
			if(IdxAuth.updateMsgToken(token, msgtoken))
				result = true
			end
		rescue Exception => e
			puts "exception #{e}"
		end

		puts "setting #{result}"
		msg = { result: result }

		render json: msg
	end
		
	
	private
	def appsetting_params
		params.permit(:token, :msgtoken, :os_type)
	end
	
    def day_param
		param = params.permit(:day)
		
		day = param[:day]
		if(day.present? && date_valid?(day))
			return day
		else
			return nil 
		end
    end
	
	def date_valid?(date)
		format = '%Y-%m-%d'
		DateTime.strptime(date, format) 
		Time.zone.iso8601(date)
		true
	rescue ArgumentError
		false
	end
	
end