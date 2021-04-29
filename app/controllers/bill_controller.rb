# 빌 단가
class BillController  < ApplicationController
	before_action :checkuser, :getlastday
	
	#ppt 52
	#빌단가
	def priceavg
		if(params[:month].blank?)
			return
		end
		
		month = params[:month]
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		@mvalue = month
		@type = params[:type]
		@yearvalue = month[-0..3]
		@monthvalue =  month[5..-1]
		@roomtype = IdxPage.getpagelists(current_user)	
		month = month.delete("-")
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplist2(current_user['bb_shoplist'])
		end
		
		# 주중 주말 매장 별
		if @type == "1"
			@weekshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@weekshops[shop['shop_nm']] = TbSfgbill.search_week_price_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				# 그룹별
				@week =  TbSfgbill.search_week_price(month)
				# 매장 별
				@week.each do |shop|
					if shop['cat_short'] == 'SFG'
						next
					end
					@weekshops[shop['cat_short']] = TbSfgbill.search_week_price_shop(month, shop['cat_short'])
				end
				
				@week = resultsort(@week)
				
			else
				return
			end
	   #점심, 저녁
		elsif @type == "2"
			@lunchshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@lunchshops[shop['shop_nm']] = TbSfgbill.search_lunch_price_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				@lunch = TbSfgbill.search_lunch_price(month)
				@lunch.each do |shop|
					if shop['cat_short'] == 'SFG'
						next
					end
					@lunchshops[shop['cat_short']] = TbSfgbill.search_lunch_price_shop(month, shop['cat_short'])
				end

				@lunch = resultsort(@lunch)
				
			else
				return
			end
		else
			@mealshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@mealshops[shop['shop_nm']] = TbSfgbill.search_meal_price_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#육류/식사
				@meal = TbSfgbill.search_meal_price(month)	
				#육류/식사 매장 별
				@meal.each do |shop|
					if shop['cat_short'] == 'SFG'
						next
					end
					@mealshops[shop['cat_short']] = TbSfgbill.search_meal_price_shop(month, shop['cat_short'])
				end
				
				@meal = resultsort(@meal)
			
			else
				return
			end
		end
	end
	
	
	#빌단가 비교
	def pricecompare
		if(params[:month].blank?)
			return
		end
		
		month = params[:month]
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		@mvalue = month
		@type = params[:type]
		@yearvalue = month[-0..3]
		@monthvalue =  month[5..-1]
		@roomtype = IdxPage.getpagelists(current_user)
		month = month.delete("-")
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplist2(current_user['bb_shoplist'])
		end
		
		if @type == "1"
			@weekshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@weekshops[shop['shop_nm']] = TbSfgbill.search_week_price_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#주중 주말
				@week = TbSfgbill.search_week_price_previousmonth_compairson(month)
				# 주중 주말 매장 별
			
				@week.each do |key, value|
					if key == 'SFG'
						next
					end
					@weekshops[key] = TbSfgbill.search_week_price_shop_previousmonth_compairson(month, key)
				end

				@week = resultsortcompare(@week)

			else
				return
			end
		elsif @type == "2"
			@lunchshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@lunchshops[shop['shop_nm']] = TbSfgbill.search_lunch_price_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				@lunch = TbSfgbill.search_lunch_price_previousmonth_compairson(month)
				@lunch.each do |key, value|
					if key == 'SFG'
						next
					end
					@lunchshops[key] = TbSfgbill.search_lunch_price_shop_previousmonth_compairson(month, key)
				end

				@lunch = resultsortcompare(@lunch)
				
			else
				return
			end
		else
			@mealshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@mealshops[shop['shop_nm']] = TbSfgbill.search_meal_price_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				@meal = TbSfgbill.search_meal_price_previousmonth_compairson(month)	
				@meal.each do |key, value|
					if key == 'SFG'
						next
					end
					@mealshops[key] = TbSfgbill.search_meal_price_shop_previousmonth_compairson(month, key)
				end

				@meal = resultsortcompare(@meal)
				
			else
				return
			end
		end
	end
	
	#ppt 54
	#빌수 
	def pieceavg
		if(params[:month].blank?)
			return
		end
		
		month = params[:month]
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		@mvalue = month
		@type = params[:type]
		
		@yearvalue = month[-0..3]
		@monthvalue =  month[5..-1]
		@roomtype = IdxPage.getpagelists(current_user)	
		
		month = month.delete("-")
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplist2(current_user['bb_shoplist'])
		end

		if @type == "1"
			@weekshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@weekshops[shop['shop_nm']] = TbSfgbill.search_week_piece_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#주중 주말
				@week =  TbSfgbill.search_week_piece(month)
				# 주중 주말 매장 별
				@week.each do |shop|
					if shop['cat_short'] == 'SFG'
						next
					end
					@weekshops[shop['cat_short']] = TbSfgbill.search_week_piece_shop(month, shop['cat_short'])
				end
					
				@week = resultsort(@week)
			else 
				return
			end
		elsif @type == "2"
			@lunchshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@lunchshops[shop['shop_nm']] = TbSfgbill.search_lunch_piece_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#점심, 저녁
				@lunch = TbSfgbill.search_lunch_piece(month)
				#점심, 저녁 매장 별
				
				@lunch.each do |shop|
					if shop['cat_short'] == 'SFG'
						next
					end
					@lunchshops[shop['cat_short']] = TbSfgbill.search_lunch_piece_shop(month, shop['cat_short'])
				end
				
				@lunch = resultsort(@lunch)
				
			else
				return
			end
		else
			@mealshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@mealshops[shop['shop_nm']] = TbSfgbill.search_meal_piece_shop_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#육류/식사
				@meal = TbSfgbill.search_meal_piece(month)	
				#육류/식사 매장 별
				
				@meal.each do |shop|
				if shop['cat_short'] == 'SFG'
						next
					end
					@mealshops[shop['cat_short']] = TbSfgbill.search_meal_piece_shop(month, shop['cat_short'])
				end
				
				@meal = resultsort(@meal)
				
			else
				return
			end
			
		end
	end
		
	#빌수 비교
	def piececompare
		if(params[:month].blank?)
			return
		end
		
		month = params[:month]
		@reportrooms = Reportroom.getLatestReportContent_with_auth(current_user, 20)
		@mvalue = month
		@type = params[:type]
		@yearvalue = month[-0..3]
		@monthvalue =  month[5..-1]
		@roomtype = IdxPage.getpagelists(current_user)
		month = month.delete("-")
		if isGROUP || isSHOP
			shoplist = IdxShoptotal.selectinfo_with_shoplist2(current_user['bb_shoplist'])
		end
		
		if @type == "1"
			@weekshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@weekshops[shop['shop_nm']] = TbSfgbill.search_week_piece_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#주중 주말
				@week = TbSfgbill.search_week_piece_previousmonth_compairson(month)
				# 주중 주말 매장 별
				@week.each do |key, value|
					if key == 'SFG'
						next
					end
					@weekshops[key] = TbSfgbill.search_week_piece_shop_previousmonth_compairson(month, key)
				end
				
				@week = resultsortcompare(@week)
			else
				return
			end
		elsif @type == "2"
			@lunchshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@lunchshops[shop['shop_nm']] = TbSfgbill.search_lunch_piece_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#점심, 저녁
				@lunch = TbSfgbill.search_lunch_piece_previousmonth_compairson(month)
				#점심, 저녁 매장 별
				@lunch.each do |key, value|
					if key == 'SFG'
						next
					end
					@lunchshops[key] = TbSfgbill.search_lunch_piece_shop_previousmonth_compairson(month, key)
				end
				
				@lunch = resultsortcompare(@lunch)
				
			else
				return
			end
		else
			@mealshops = Hash.new
			if isGROUP || isSHOP
				shoplist.each do |shop|
					@mealshops[shop['shop_nm']] = TbSfgbill.search_meal_piece_shop_previousmonth_compairson_with_shopid(month, shop['shop_id'])
				end
			elsif isVIP || isGM
				#육류/식사
				@meal = TbSfgbill.search_meal_piece_previousmonth_compairson(month)	
				#육류/식사 매장 별
				@meal.each do |key, value|
					if key == 'SFG'
						next
					end
					@mealshops[key] = TbSfgbill.search_meal_piece_shop_previousmonth_compairson(month, key)
				end
				
				@meal = resultsortcompare(@meal)
				
			else
				return
			end
		end
	end
	
	private
	
	def getlastday
		result = TbSfgbill.selectlastday
		
		@lastday = result['sfgbill_dt']
	end
	
	def resultsort(_result)
		result = Hash.new
		result['SFG'] = hashfindvalue('SFG', _result)
		result['긴자'] = hashfindvalue('긴자', _result)
		result['단일'] = hashfindvalue('단일', _result)
		result['천지'] = hashfindvalue('천지', _result)
		result['천+송'] = hashfindvalue('천+송', _result)
		result['송도'] = hashfindvalue('송도', _result)
		result['우설'] = hashfindvalue('우설', _result)
		result['기타'] = hashfindvalue('기타', _result)
		result['돈블'] = hashfindvalue('돈블', _result)
		result['자작'] = hashfindvalue('자작', _result)
		
		return result
	end
	
	def hashfindvalue(_value, _hash)
		find = _hash.select{ |value| value['cat_short'] == _value } 
		
		if find.present?
			if find.length > 0
				return find[0]
			end
		end

		return nil
	end
	
	def resultsortcompare(_result)
		result = Hash.new
		result['SFG'] = comparehashfindvalue('SFG', _result)
		result['긴자'] = comparehashfindvalue('긴자', _result)
		result['단일'] = comparehashfindvalue('단일', _result)
		result['천지'] = comparehashfindvalue('천지', _result)
		result['천+송'] = comparehashfindvalue('천+송', _result)
		result['송도'] = comparehashfindvalue('송도', _result)
		result['우설'] = comparehashfindvalue('우설', _result)
		result['기타'] = comparehashfindvalue('기타', _result)
		result['돈블'] = comparehashfindvalue('돈블', _result)
		result['자작'] = comparehashfindvalue('자작', _result)
		
		return result
	end
	
	def comparehashfindvalue(_key, _hash)
		find = _hash.select{ |key, value| key == _key } 
		
		if find.present?
			if find.values.length > 0
				return find.values[0]
			end
		end

		return nil
	end
	
end