class MainController < ApplicationController
	before_action :checkuser
	
	def index
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		
		@companylist_top = TbSfgshwng.getcompanylist_top
		
		@companylist_bottom = TbSfgshwng.getcompanylist_bottom
		
		@latelysales_list = TbSalesDaily.latelysales
		@sell_month = TbSalesDaily.sell_month
		
	
		
		@latelysales_list.each do |value|			
			value['sales'] = value['sales'].to_s[0..-9].insert(-3, '.');
			value['date'] = value['date'].strftime('%m.%d') + '/' + value['wk']
		end
		
		@standarddate = TbSfgshwng.getstandarddate
		
		@sfg = Cubedb::VShSalesCurrent.sfg_sum_without_j
				
		#start 차트 데이터 계산.
		@result = Cubedb::VShSalesCurrent.sfg_sum_time

		@result = @result.values.to_a
=begin
		per = 0.0001
		
		@result = [ @chartresult[0].to_i * per, @chartresult[10].to_i * per, @chartresult[11].to_i * per, @chartresult[12].to_i * per,
				    @chartresult[13].to_i * per, @chartresult[14].to_i * per, @chartresult[15].to_i * per, @chartresult[16].to_i * per,
				    @chartresult[17].to_i * per, @chartresult[18].to_i * per, @chartresult[19].to_i * per, @chartresult[20].to_i * per,
				    @chartresult[21].to_i * per, @chartresult[22].to_i * per ]

		@result2 = [ ]
		
		for i in 0..14 do
			@result[i] = @result[i].to_i;
		end
=end
		@result2 = @result.dup;

		for i in 1..13 do
			if(@result2[i] != 0)
				@result2[i] = @result2[i-1] + @result2[i]
			end
		end

		result = TbSfgbill.selectlastday
		if result.present? 
			if result['sfgbill_dt'].present?
				@pre_month = result['sfgbill_dt'].strftime("%Y-%m")
			end
		end
		
		 
		#end 차트 데이터 계산.		
		
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	def temp
		result = Cubedb::VShSalesCurrent.sfg_sum_time
		
		value = 100000;
	
		render json: number_to_currency(value)
		
	end
	
	def sales_report
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	def yield_management
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	def performance_management
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	def business_evaluation
		@roomtype = IdxPage.getpagelists(current_user)
	end

	
	def testview_3
		
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		
		@companylist_top = TbSfgshwng.getcompanylist_top
		
		@companylist_bottom = TbSfgshwng.getcompanylist_bottom
		
		@latelysales_list = TbSalesDaily.latelysales
		
		
	
		
		@latelysales_list.each do |value|			
			value['sales'] = value['sales'].to_s[0..-9].insert(-3, '.');
			value['date'] = value['date'].strftime('%m.%d') + '/' + value['wk']
		end
		
		@standarddate = TbSfgshwng.getstandarddate
		
		@sfg = Cubedb::VShSalesCurrent.sfg_sum_without_j
				
		#start 차트 데이터 계산.
		@result = Cubedb::VShSalesCurrent.sfg_sum_time

		@result = @result.values.to_a
=begin
		per = 0.0001
		
		@result = [ @chartresult[0].to_i * per, @chartresult[10].to_i * per, @chartresult[11].to_i * per, @chartresult[12].to_i * per,
				    @chartresult[13].to_i * per, @chartresult[14].to_i * per, @chartresult[15].to_i * per, @chartresult[16].to_i * per,
				    @chartresult[17].to_i * per, @chartresult[18].to_i * per, @chartresult[19].to_i * per, @chartresult[20].to_i * per,
				    @chartresult[21].to_i * per, @chartresult[22].to_i * per ]

		@result2 = [ ]
		
		for i in 0..14 do
			@result[i] = @result[i].to_i;
		end
=end
		@result2 = @result.dup;

		for i in 1...12 do
			if(@result2[i] != 0)
				@result2[i] = @result2[i-1] + @result2[i]
			end
		end

		result = TbSfgbill.selectlastday
		@pre_month = result['sfgbill_dt'].strftime("%Y-%m") 
		
		 
		#end 차트 데이터 계산.		
		
		@roomtype = IdxPage.getpagelists(current_user)

		#day  = (Date.today - 1.month).strftime("%Y-%m")  
		 
		
		#@startday_2 = ( DateTime.parse("2020-12-01") - 364.day).strftime("%y.%m.%d")  

		#@startday_1 = DateTime.parse("2020-12-01").strftime("%y.%m.%d")  

		#@roomtype = IdxPage.getpagelists(current_user)
		#render json: @startday_1
		
		#day = day

		
		
		#render json: ( DateTime.parse("2021-02-01") - 364.day).strftime("%y-%m-%d")  
		
		
	end
	
end