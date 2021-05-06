class Reportroom < ApplicationRecord
	has_one :attachfile
	
	$timezoneformat = "'+00:00', '+09:00'".freeze
	
	# 보고서 저장
	def self.newreport(_user, _params)
	
		sql = nil
		if(_params[:addresult] == '1')
			sql = "INSERT INTO reportrooms ( roomtype, userid, contents, plancontents, bb_shoplist, created_at, updated_at ) VALUES( '%{type}', '%{userid}', '%{content}', '%{plancontent}', '%{shoplist}', now(), now()); " % [type: _params[:type], userid: _user['idx_ccu_id'], content: _params[:contents], plancontent: _params[:plancontents], shoplist: _user['bb_shoplist']]
		else
			sql = "INSERT INTO reportrooms ( roomtype, userid, contents, plancontents, created_at, updated_at ) VALUES( '%{type}', '%{userid}', '%{content}', '%{plancontent}', now(), now()); " % [type: _params[:type], userid: _user['idx_ccu_id'], content: _params[:contents], plancontent: _params[:plancontents]]
		end

		#DateTime.current.to_s(:db)])
		#Time.now.to_s(:db)

		return connection.insert(sql)
	end
	
	# 보고서 찾기
	def self.findreport(_id)
		queryresult = connection.select_one("SELECT id, roomtype, contents, plancontents, bb_shoplist, CONVERT_TZ(created_at, %{timezone}) AS created_at, IF ( datediff(CONVERT_TZ(created_at, %{timezone}), CONVERT_TZ(now(), %{timezone})) = 0, 1, 2 ) as timetype, s_nm FROM reportrooms left JOIN idx_ccu_id on reportrooms.userid = idx_ccu_id.ccu_id WHERE id = '%{id}';" % [id: _id, yearformat: '%Y-%m-%d', timeformat: '%h:%i', dayformat: '%m-%d', timezone: $timezoneformat] )
=begin
		if queryresult.present? 
			queryresult['contents'] = queryresult['contents'].gsub("\r", "<br>")
			queryresult['contents'] = queryresult['contents'].gsub("\t", "&nbsp;")
			#queryresult['contents'] = queryresult['contents'].html_safe

			queryresult['plancontents'] = queryresult['plancontents'].gsub("\r", "<br>")
			queryresult['plancontents'] = queryresult['plancontents'].gsub("\t", "&nbsp;")
			#queryresult['plancontents'] = queryresult['plancontents'].html_safe
		end
=end
		return queryresult;
	end


	def self.showreportlist(_user)
		
		tables = getwritepages("roomtype", _user)
		if(tables.nil?)
			return nil
		end
		return connection.select_all("SELECT  id, roomtype, userid, contents, plancontents, bb_shoplist, CONVERT_TZ(created_at, %{timezone}) AS created_at, IF ( datediff(CONVERT_TZ(created_at, %{timezone}), CONVERT_TZ(now(), %{timezone})) = 0, 1, 2 ) as timetype, bb_nm FROM reportrooms LEFT JOIN idx_pages ON reportrooms.roomtype = idx_pages.bb_id WHERE %{tables} AND DATEDIFF(created_at, DATE_FORMAT(now(), '%{yearformat}')) >= -%{rangeday} ORDER BY created_at DESC;" % [tables: tables, dayformat: '%m-%d', timeformat: '%H:%i', yearformat: '%Y-%m-%d', timezone: $timezoneformat, rangeday: _day] )
	end

	#보고 방 조회 
	def self.getLatestReportContent(_limit = nil)
		selectquery = "SELECT id, roomtype, userid, contents, plancontents, bb_shoplist, bb_nm, ccu_nm FROM reportrooms LEFT JOIN idx_pages ON roomtype = bb_id LEFT JOIN idx_ccu_id ON userid = idx_ccu_id ORDER BY created_at DESC"
		
		if(_limit.nil?)
			selectquery += ";";
		else
			selectquery += " limit #{_limit};"
		end
		
		return connection.select_all(selectquery)
	end
	
	#보고방 조회 with 권한
	def self.getLatestReportContent_with_auth(_user, _limit = nil)
		tables = getreadpages("roomtype", _user)
		basequery = "SELECT id, roomtype, userid, contents, plancontents, bb_shoplist, bb_nm, ccu_nm, CONVERT_TZ(created_at, %{timezone}) AS created_at, IF ( DATEDIFF(CONVERT_TZ(created_at, %{timezone}), CONVERT_TZ(now(), %{timezone})) = 0, 1, 2 ) as timetype FROM reportrooms LEFT JOIN idx_pages ON roomtype = bb_id LEFT JOIN idx_ccu_id ON userid = idx_ccu_id" % [timezone: $timezoneformat ]
		
		selectquery = nil
		if(tables.nil?)
			selectquery = "#{basequery} ORDER BY created_at DESC"
		else
			selectquery = "#{basequery} WHERE %{tables} ORDER BY created_at DESC" % [tables: tables]
		end
		
		if(_limit.nil?)
			selectquery += ";";
		else
			selectquery += " limit #{_limit};"
		end
		
		return connection.select_all(selectquery)
	end

	#보고서 타입, 날짜 조회
	def self.getTypeLatestReportContent(_roomtype, _day, _limit = nil)
		selectquery = "SELECT id, roomtype, userid, contents, plancontents, bb_shoplist, bb_nm, ccu_nm, CONVERT_TZ(created_at, %{timezone}) AS created_at, IF ( DATEDIFF(CONVERT_TZ(created_at, %{timezone}), CONVERT_TZ(now(), %{timezone})) = 0, 1, 2 ) as timetype, TIMESTAMPDIFF(hour, created_at, now()) as modify FROM reportrooms LEFT JOIN idx_pages ON roomtype = bb_id LEFT JOIN idx_ccu_id ON userid = idx_ccu_id WHERE roomtype = '%{roomtype}' AND DATEDIFF(created_at, now()) >= -%{rangeday} ORDER BY created_at DESC" % [dayformat: '%m-%d', timeformat: '%H:%i', yearformat: '%Y-%m-%d', roomtype: _roomtype,  timezone: $timezoneformat, rangeday: _day]
		
		if(_limit.nil?)
			selectquery += ";";
		else
			selectquery += " limit #{_limit};"
		end
		
		return connection.select_all(selectquery)

	end
	
	#보고서 업데이트
	def self.updateReport(_user, _params, _changeparams)
		
		sql = nil

		if(_changeparams[:addresult] == "1")
			sql = "UPDATE reportrooms SET contents = '%{content}', plancontents = '%{plancontents}', bb_shoplist = '%{shoplist}', updated_at = now() WHERE id = '%{id}';" % [content: _changeparams['contents'], plancontents: _changeparams['plancontents'], shoplist: _user['bb_shoplist'], id: _params['id'] ]
		else
			sql = "UPDATE reportrooms SET contents = '%{content}', plancontents = '%{plancontents}', bb_shoplist = '', updated_at = now() WHERE id = '%{id}';" % [content: _changeparams['contents'], plancontents: _changeparams['plancontents'], id: _params['id'] ]
		end
		
		
		begin
			transaction do
		 		connection.update(sql)
			end
		rescue ActiveRecord::RecordInvalid => exception
			Rails.logger.error "Reportroom updateReport Error #{exception}"
			Rollback			
		end
	end
	
	#보고서 삭제
	def self.deleteReport(_id)
		result = true
		begin
			transaction do
				connection.delete("DELETE FROM reportrooms WHERE id = '#{_id}'; " )
			end
		rescue ActiveRecord::RecordInvalid => exception
			Rails.looger.error "Reportroom deleteReport Error #{exception}"
			result = false
			Rollback			
		end
		return result
	end

	private
		

end
