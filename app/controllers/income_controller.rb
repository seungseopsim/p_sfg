# 손익 관리

class IncomeController  < ApplicationController
	before_action :checkuser
	
	def index
		#result = TbSfgpl.search_business("201910", "돈블", "본사")
		result = TbSfgpl.search_shop("201910", "돈블", "SH1010")
		render json: result
	end
	
	
	def business
		if(params[:sort].blank? || params[:div].blank?)
			return
		end
		
		month = params[:month]
		sort = params[:sort]
		div =  params[:div]
			
		result = TbSfgpl.search_business("201910", "돈블", "본사")
	end
	
	def shop
		if(params[:sort].blank? || params[:shop].blank?)
			return
		end
		
		month = params[:month]
		sort = params[:sort]
		div =  params[:shop]
		
		result = TbSfgpl.search_shop("201910", "돈블", "SH1010")
		render json: result
	end
end