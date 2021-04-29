class ReportroomsController < ApplicationController
	include FcmHelper
	before_action :set_reportroom, only: [:show, :update, :destroy]
	before_action :checkuser
  	
	$selectdayrange = 7		#조회 범위 날짜
	$selectlimit = 3		#조회 갯수 제한
	
  # GET /reportrooms
  # GET /reportrooms.json
  def index
    #@reportrooms = Reportroom.showreportlist(current_user)
  end
  
  def read
	  param = params.permit(:type, :id)
	  if !param.present?
		 return 
	  end
	  
	  id = param[:id]
	  type = param[:type]
	  
	  result = setreportcookies(type, id)
	  render json: {id: result}
  end
	
  # GET /reportrooms/1
  # GET /reportrooms/1.json
  def show
	  if @reportroom.blank?
		return
	end
	  
	@shopinfo = TbSfgshwng.getshopinfo(@reportroom['bb_shoplist'])
	if( !@reportroom.nil? && @reportroom['id'].present? )
		@attachfiles = Attachfile.findfiles(@reportroom['id'])
	end
	  
	if(!@shopinfo.blank? && @shopinfo.length > 1)
		@day = TbSfgshwng.selectlastday
		@shopinfototal = TbSfgshwng.getshopinfoTotal(@reportroom['bb_shoplist'])
	end  
  end 

	
  # GET /reportrooms/new
  def new
	@reportroom = Reportroom.new
	@roomtype = IdxPage.getpagelists(current_user)
  end
	
  def typelist	

		if( readP00? )
			@p00 = Reportroom.getTypeLatestReportContent('P00', $selectdayrange, $selectlimit)
		end
		if( readbb101? ) 
			@bb101 = Reportroom.getTypeLatestReportContent('bb101', $selectdayrange, $selectlimit)
		end
		if( readbb102? ) 
			@bb102 = Reportroom.getTypeLatestReportContent('bb102', $selectdayrange, $selectlimit)
		end
		if( readbb103? )
			@bb103 = Reportroom.getTypeLatestReportContent('bb103', $selectdayrange, $selectlimit)
		end
		if( readbb104? )
			@bb104 = Reportroom.getTypeLatestReportContent('bb104', $selectdayrange, $selectlimit)
		end
		if( readbb201? )
			@bb201 = Reportroom.getTypeLatestReportContent('bb201', $selectdayrange, $selectlimit)
		end
		if( readbb202? )
			@bb202 = Reportroom.getTypeLatestReportContent('bb202', $selectdayrange, $selectlimit)
		end	
		if( readbb203? )
			@bb203 = Reportroom.getTypeLatestReportContent('bb203', $selectdayrange, $selectlimit)
		end
		if( readbb204? )  
			@bb204 = Reportroom.getTypeLatestReportContent('bb204', $selectdayrange, $selectlimit)
		end
		if( readbb205? )  
			@bb205 = Reportroom.getTypeLatestReportContent('bb205', $selectdayrange, $selectlimit)
		end
		if( readbb206? )  
			@bb206 = Reportroom.getTypeLatestReportContent('bb206', $selectdayrange, $selectlimit)
		end
		if( readbb207? )  
			@bb207 = Reportroom.getTypeLatestReportContent('bb207', $selectdayrange, $selectlimit)
		end
		if( readbb208? )  
			@bb208 = Reportroom.getTypeLatestReportContent('bb208', $selectdayrange, $selectlimit)
		end
	  
	    @roomtype = IdxPage.getpagelists(current_user)
  end
 
  def type
	
	roomtype = params.permit(:type)
	if( !roomtype.present? )
		return	
	end
	  
	roomtype = roomtype[:type]
	  
	@bbinfo = IdxPage.getinfo(roomtype)
	@reports = Reportroom.getTypeLatestReportContent(roomtype, $selectdayrange)	 
	@roomtype = IdxPage.getpagelists(current_user)
	checkreadreport(roomtype, @reports)  
  end
	
  # GET /reportrooms/1/edit
  def edit
	@roomtype2 = IdxPage.getpagelists(current_user)
	@reportroom = Reportroom.find_by(id: params[:id])
	@roomtype = IdxPage.getpage(@reportroom['roomtype'])
    if( !@reportroom.nil? && @reportroom['id'].present? )
		@attachfiles = Attachfile.findfiles(@reportroom['id'])
		@attachfiles.to_a
	end
  end

  # POST /reportrooms
  # POST /reportrooms.json
  def create
	if( reportroom_params[:type].present? and reportroom_params[:contents].present? )
		# and params[:reportroom][:plancontents].present?
	else
		puts "저장 불가"
		flash[:notice] = '저장 불가'
		return
	end
	  
    reportid = Reportroom.newreport(current_user,  reportroom_params)
	if( reportid > 0)
		Attachfile.addfiles(reportid, reportroom_params)
	end
	
	  
	#페이지 처리
	redirect_to type_reportrooms_path(reportroom_params[:type])
	  
	# push 처리
	title = "#{current_user['s_nm']} #{current_user['ccu_nm']}"
	msg = reportroom_params[:contents][0..20]
	pushtargets = IdxAuth.getpushtargets(current_user['idx_ccu_id'], reportroom_params[:type])  
	push = sendpushtargets(pushtargets, title, msg)

  end

  # PATCH/PUT /reportrooms/1
  # PATCH/PUT /reportrooms/1.json
  def update
	
	 reportroom = Reportroom.find_by(id: params[:id])
	 if(reportroom.nil?)
		redirect_to root_path
	 end
	  
	 limitTime = (DateTime.current.to_time - reportroom['created_at']) / 1.hour
	 
	 #puts "current #{DateTime.current.to_time}"
	 #puts "create_at #{reportroom['created_at']}"
	 #puts "limitTime #{limitTime}"
	  puts "update bbshop #{current_user['bb_shoplist']}"
	 @roomtype = IdxPage.getpage(@reportroom['roomtype'])
	 if !vaildModify( limitTime )
		 puts 'no change'
		 flash[:notice] = '수정 불가'
	 	 redirect_to notice: '수정 불가'
		 return
	 end
	  

				
      if Reportroom.updateReport(current_user, @reportroom, reportroom_params)
		Attachfile.updatefiles(@reportroom['id'], reportroom_params)
		redirect_to type_reportrooms_path(@reportroom['roomtype'])
      else
		respond_to do |format|
        	format.html { render :edit }
        	format.json { render json: @reportroom.errors, status: :unprocessable_entity }
      	end
      end
  end

  # DELETE /reportrooms/1
  # DELETE /reportrooms/1.json
  def destroy

	reportroom = Reportroom.find_by(id: params[:id])
	if(reportroom.nil?)
		redirect_to '/'
		return
	end

	if isPUser
		#관리자 계정 
		
	else
		limitTime = (DateTime.current.to_time - reportroom['created_at']) / 1.hour

		if( limitTime > $modifytime)
			 puts 'no delete'
				flash[:notice] = '삭제 불가'
				redirect_to type_reportrooms_path( @roomtype['bb_id']), notice: "삭제 불가"
			 return
		end
	end
	  
	@roomtype = IdxPage.getpage(reportroom['roomtype']) 
	  
	if Attachfile.deletefiles(reportroom[:id])
    	Reportroom.deleteReport(reportroom[:id])
	end
	  
    respond_to do |format|
      format.html { redirect_to type_reportrooms_path( @roomtype['bb_id']), notice: '성공적으로 삭제 되었습니다.' }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reportroom
      @reportroom = Reportroom.findreport(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reportroom_params
      params.require(:reportroom).permit(:type, :contents, :plancontents, :addresult, {attachment:[]})
    end
	
	
	# report cookes
	# 읽기 처리
	def setreportcookies(_type, _id)
		#key = "#{userkey}r#{_id}"
		#key = Base64.strict_encode64(key)
		#key = key[0..18]
		#if cookies.encrypted[key]
		#	return _id
		#end
		
		#cookies.encrypted[key] = {
		#	value: "1",
		#	expires: 1.days
		#}
		#find = ReportroomsReadinfo.kk()
		#if !find.present? 
			
		#end
		ReportroomsReadinfo.update(_type, _id, userkey)
		return _id
	end
	
	def getreportcookies(_id)
		key = "#{userkey}r#{_id}"
		key = Base64.strict_encode64(key)
		key = key[0..18]
		return key, cookies.encrypted[key] 
	end 
	
	def checkreadreport(_roomtype,  _recordlist)
		if _recordlist.blank?
			return
		end
		
		_recordlist.each do | info |
			id = info['id']
			#info['read'] = getreportcookies(info['id'])
			#if true == getreportcookies(info['id'])
			#	info['read'] = true
			#else
			#	info['read'] = false
			#end			
		#	key = "#{userkey}report#{info['id']}"
		#	info['read'] = 	"#{key} #{cookies[key]}"
			cnt = ReportroomsReadinfo.count(_roomtype, id, userkey)
			
			info['read'] = cnt == 1 ? true : false
		end
	end
end
