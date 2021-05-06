Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	scope :main do
		get '/',							to: "main#index",			as: "index_main"

		get 'yield_management',  			to: "main#yield_management"
		get 'sales_report',		 			to: "main#sales_report" 
		get 'performance_management',		to: "main#performance_management" 
		get 'business_evaluation',		    to: "main#business_evaluation" 
		get 'toilet_check',		    		to: "main#toilet_check" 
	end
	
	root 						to: 'sessions#new'
	
	resources :reportrooms do
		collection do
			get 'typelist',		to: "reportrooms#typelist", as: :typelist
			get 'type/:type',	to: "reportrooms#type", 	as: :type
			post 'read',		to: "reportrooms#read"
			get 'download',		to: "reportrooms#download"
		end
	end
	
	scope :login do	
		get 'new',				to: 'sessions#new',			as: :login
		post 'signin',			to: 'sessions#create'
		post 'auto',			to: 'sessions#auto'
		delete 'delete',		to:	'sessions#destroy'
	end
 
	scope :analysis do
		get 'current',			to: 'sales_analysis#current' 			#ppt 45
		get 'day',				to: 'sales_analysis#day'	 			#ppt 46
		get 'range',			to: 'sales_analysis#range'  			#ppt 47, 48
		get 'rangemonth',		to: 'sales_analysis#rangemonth'			#ppt 49
	end
	
	scope :bill do
		get 'priceavg',				to: "bill#priceavg"					#ppt 52
		get 'pricecompare',			to: "bill#pricecompare"				#ppt 54
		get 'pieceavg',				to: "bill#pieceavg"					#ppt 56
		get 'piececompare',			to: "bill#piececompare"				#ppt 58
	end
	
	namespace :cubedb do
		get 'v_sh_sales_daily' 
		get 'index'
		get 'index2'
	end

	#연동 처리
	scope :link do
		get 'idxinvt',				to: "link#idxinvt"
		get 'idxshop',				to: "link#idxshop"
		get 'cos_daily',			to: "link#cos_daily"
		get 'sales_daily',			to: "link#sales_daily"
		get 'sales_detail',			to: "link#sales_detail"
		get 'sales_bill',			to: "link#sales_bill"
		get 'so_detail',			to: "link#so_detail"
		get 'ppc_use',				to: "link#ppc_use"
		get 'ppc_save',				to: "link#ppc_save"
		get 'tbinvt',				to: "link#tbinvt"
	end
	
	#서버 상태 확인용
	get 'liveness_check',			to: "livecheck#liveness_check"
	
	get 'readiness_check',			to: "livecheck#readiness_check"
        
	post 'setting',					to: "link#setting"
	
end
