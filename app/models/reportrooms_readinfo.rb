class ReportroomsReadinfo < ApplicationRecord
	
	def self.update(_roomtype, _reportid, _userid)
		find = select(_roomtype, _reportid, _userid)

		if find.blank?
			insert(_roomtype, _reportid, _userid)
		else
			query = "UPDATE reportrooms_readinfos SET last_read_at = now() WHERE roomtype = '#{_roomtype}' AND reportid = '#{_reportid}' AND userid = '#{_userid}';"
			connection.update(query)
		end
	end
	
	def self.insert(_roomtype, _reportid, _userid)
		query = "INSERT INTO reportrooms_readinfos (roomtype, reportid, userid, first_read_at, last_read_at ) VALUES('#{_roomtype}','#{_reportid}','#{_userid}', now(), now() ); "
		return connection.insert(query)
	end

	def self.select(_roomtype, _reportid, _userid)
		query = "SELECT * FROM reportrooms_readinfos AS A LEFT JOIN reportrooms AS B On A.reportid = B.id WHERE A.roomtype = '#{_roomtype}' AND A.reportid = '#{_reportid}' AND A.userid = '#{_userid}';"
		
		return  connection.select_one(query)
	end
	
	def self.count(_roomtype, _reportid, _userid)
		query = "SELECT COUNT(reportid) AS CNT FROM reportrooms_readinfos AS A LEFT JOIN reportrooms AS B On A.reportid = B.id WHERE A.roomtype = '#{_roomtype}' AND A.reportid = '#{_reportid}' AND A.userid = '#{_userid}';"
		
		result = connection.select_one(query)
		return result['CNT']
	end
end