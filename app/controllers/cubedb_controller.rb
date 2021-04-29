class CubedbController < ApplicationController
	
	def index
		
		#results = Cubedb::VShSalesDaily.selectdaily("2020-12-20")
		
		
		cubedata = Cubedb::VShCosDaliy.selectall
		results = TbCosDaily.insert(cubedata)
		render json:results
	end
	
	
	
	def index2					
		render json: '2'
	end
	
	
	def v_sh_sales_daily
	 	require 'tiny_tds'  
    	client = TinyTds::Client.new username: 'sh_mappif', password: 'shmappif20@)',  host: '182.162.136.249', port: 1198, database: 'CUBECENTER'
		
		date = params[:date]
		
		query = "SELECT SUM(b_real_amt) AS total FROM v_sh_sales_current;"
		#query = "select shop_id, bsn_dt, B_ID, shop_sort, sb_real_amt from v_sh_sales_daily WHERE shop_nm Like '%돈블랑%'AND bsn_dt = '" + date + "' "
		results = client.execute(query);
		
		render json: results
	end

	
end
