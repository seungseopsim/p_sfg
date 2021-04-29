class SalesAnalysisController < ApplicationController
	before_action :checkuser
	# 테스트
	def index
		result = TbSalesDaily.sfg_sum('2019-01-08', '2019-01-30')
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		@roomtype = IdxPage.getpagelists(current_user)
		render json: result
	end

	#현재 
	def current
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)

		@sfg = nil
		
		businessinfo = nil
		@business = nil
		selectkey = 's_id'
		selecttype = 1
		partname = 's_nm_short'
		
		if isGROUP || isSHOP
			businessinfo = 	IdxShoptotal.selectinfo_with_shoplists(current_user['bb_shoplist'])
			selectkey = 'shop_id'
			selecttype = 2
			partname = "shop_nm"
		elsif isVIP || isGM
			@sfg = Cubedb::VShSalesCurrent.sfg_sum_without_j
			businessinfo = Cubedb::VShSalesCurrent.business_sum	
			@business = IdxS.selectinfo
		else
			return
		end
		
		
		if businessinfo.present? && @business.present?
			@business.each do |info|			
				findbusiness = businessinfo.detect{ |lists| !lists.select{ |key, value| value == info['s_id']}.blank? }
				if findbusiness.blank? 
					info['total'] = 0
				else
					info['total'] = findbusiness['total']
				end

				#puts "info #{info['s_id']} #{findbusiness}"
			end

			# 자작 처리
			findbusiness = businessinfo.detect{ |lists| !lists.select{ |key, value| value == 'JJ01'}.blank? }
			info = @business.detect{ |info| info['s_id'] == 'SH006'}

			if !info.nil?
				if findbusiness.blank? 
					info['total'] = 0
				else
					info['total'] = findbusiness['total']
				end
			end
			# 자작 처리	
		end

		@shops = Hash.new
		
		if @business.nil? 
			businessinfo.each do |part|
				@shops[part[partname]] = Cubedb::VShSalesCurrent.shop_sum(selecttype, part[selectkey])
			end
		else
			@business.each do |part|
				@shops[part[partname]] = Cubedb::VShSalesCurrent.shop_sum(selecttype, part[selectkey])
			end
		end
		
		@day = Date.today - 2
		@startday = Date.today - 2
		@endday = Date.today - 2
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	#날짜 
	def day
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		day = params[:day]
		if(day.blank?)
			return
		end
		
		@dayvalue = day;
		
		@sfg = nil
		@business = nil
		@shops = Hash.new
		selectkey = 's_id'
		selecttype = 1
		partname = "s_nm_short"
		
		if isGROUP || isSHOP
			businessinfo = IdxShoptotal.selectinfo_with_shoplists(current_user['bb_shoplist'])
			selectkey = 'shop_id'
			selecttype = 2
			partname = "shop_nm"
		elsif isVIP || isGM
			@sfg = TbSalesDaily.sfg_sum(day)
			@business = TbSalesDaily.business_sum(day)
		else
			return
		end

		businessinfo = businessinfo.nil? ? @business : businessinfo

		findbusiness = businessinfo.detect{ |lists| !lists.select{ |key, value| value == 'SH006'}.blank? }
		if findbusiness.present?
			findbusiness['s_id'] = 'JJ01'
		end
	
		businessinfo.each do |part|
			@shops[part[partname]] = TbSalesDaily.shop_sum(selecttype, part[selectkey], day)
		end
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	#날짜별
	def range
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		startday = params[:start]
		endday = params[:end]
		if(startday.blank? || endday.blank?)
			return
		end
				
		@startday = startday
		@endday = endday
		@rangetype = params[:type]
		
		startdayparse = DateTime.parse(startday) 
		enddayparse = DateTime.parse(endday)
		@startday_1 =  startdayparse.strftime("%y.%m.%d")  
		@endday_1 = enddayparse.strftime("%y.%m.%d")  
		
		@startday_2 = ( startdayparse - 364.day).strftime("%y.%m.%d")  
		@endday_2 = ( enddayparse - 364.day).strftime("%y.%m.%d")  
					
		isSum = @rangetype == "1"
		
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplists(current_user['bb_shoplist'])
			
			if isSum
				@shops = Hash.new
				shoplist.each do |part|
					@shops[part['shop_nm']] = TbSalesDaily.shop_sum_range_with_beforyear(2, part['shop_id'], startday, endday)
				end
			else
				@shopsavg = Hash.new
				shoplist.each do |part|
					@shopsavg[part['shop_nm']] = TbSalesDaily.shop_avg_range_with_beforyear(2, part['shop_id'], startday, endday)
				end
			end
			
		elsif isVIP || isGM
			if isSum
				@shops = Hash.new
				#합계
				@sfg = TbSalesDaily.sfg_sum_range_with_beforyear(startday, endday)
				@business = TbSalesDaily.business_sum_range_with_beforyear(startday, endday)
			
				@business.each do |key, value|
					@shops[key] = TbSalesDaily.shop_sum_range_with_beforyear(1, value[:s_id], startday, endday)
				end
			else
				@shopsavg = Hash.new
				#평균
				@sfgavg = TbSalesDaily.sfg_avg_range_with_beforyear(startday, endday)
				@businessavg = TbSalesDaily.business_avg_range_with_beforyear(startday, endday)
											
				@businessavg.each do |key, part|
					@shopsavg[key] = TbSalesDaily.shop_avg_range_with_beforyear(1, part[:s_id], startday, endday)
				end
			end
		else
			return
		end
		@roomtype = IdxPage.getpagelists(current_user)
	end
	
	#월별
	def rangemonth
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		startmonth = params[:start]
		endmonth = params[:end]
		if(startmonth.blank? || endmonth.blank?)
			return
		end
		
		@startmonth = startmonth
		@endmonth = endmonth
		

		
		@year_value_1 =  startmonth[-0..3]
		@month_value_1 =  startmonth[5..-1]
		
		@year_value_2 =  endmonth[-0..3]
		@month_value_2 =  endmonth[5..-1]
		
	

		@rangetype = params[:type]
		@shops = Hash.new
		@shopsavg = Hash.new
		
		isSum = @rangetype == '1'
		@roomtype = IdxPage.getpagelists(current_user)
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplists(current_user['bb_shoplist'])
			if isSum
				shoplist.each do |part|
					@shops[part['shop_nm']] = TbSalesDaily.shop_sum_rangemonth_with_beforyear(2, part['shop_id'], startmonth, endmonth)
				end
			else
				shoplist.each do |part|
					@shopsavg[part['shop_nm']] = TbSalesDaily.shop_avg_rangemonth_with_beforyear(2, part['shop_id'], startmonth, endmonth)
				end
			end
		elsif isVIP || isGM
			if isSum

				#합계
				@sfg = TbSalesDaily.sfg_sum_rangemonth_with_beforyear(startmonth, endmonth)
				@business = TbSalesDaily.business_sum_rangemonth_with_beforyear(startmonth, endmonth)
	
				@business.each do |key, part|
					@shops[key] = TbSalesDaily.shop_sum_rangemonth_with_beforyear(1, part[:s_id], startmonth, endmonth)
				end				
			else
				#평균
				@sfgavg = TbSalesDaily.sfg_avg_rangemonth_with_beforyear(startmonth, endmonth)
				@businessavg = TbSalesDaily.business_avg_rangemonth_with_beforyear(startmonth, endmonth)
							
				@businessavg.each do |key, part|
					@shopsavg[key] = TbSalesDaily.shop_avg_rangemonth_with_beforyear(1, part[:s_id], startmonth, endmonth)
				end
			end
		else
			return
		end
		
	end
	
	def sales_view_1
		@vlaue = "V"
	end
	
	def sales_view_2

	end
	
	def sales_view_3

	end
	
	def sales_view_4

	end
	private 
	
end