class LinkController < ApplicationController
	# 연동 처리	
	protect_from_forgery unless:  -> { request.format.json? }, only: [:setting]
		
	def idxinvt
		result = IdxInvt.insert
		render json: result
	end
	
	def idxshop
		result = IdxShop.insert
		render json: result
	end	
	
	#일별 식자재비율	
	def cos_daily
		day = day_param
		result = TbCosDaily.insert(day)
		render json: result
	end

	#일별 마감매출
	def sales_daily
		day = day_param
		result = TbSalesDaily.insert(day)
		render json: result
	end
	
	#메뉴별 판매현황
	def sales_detail
		day = day_param		
		result = TbSalesDetail.insert_withThread(day)
		render json: result
	end
	
	#빌 단위 판매현황
	def sales_bill
		day = day_param
		result = TbSalesBill.insert_withThread(day)
		render json: result
	end
	
	# 사업현황
	def so_detail
		day = day_param
		result = TbSoDetail.insert_withThread(day)
		render json: result
	end
	
	#선불카드 사용현황
	def ppc_use
		day = day_param
		result = TbPpcUse.insert(day)
		render json: result
	end
	
	# 선불카드 적립현황
	def ppc_save
		day = day_param
		result = TbPpcSave.insert(day)
		render json: result
	end
	
	# 주요 식자재 재고현황 및 수율
	def tbinvt
		day = day_param
		result = TbInvt.insert(day)
		render json: result
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
			return Date.yesterday 
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