class IdxPage < ApplicationRecord
	
	
	# 사용 가능한 페이지 정보 가져오기
	def self.getpagelists(_user)
		
		tables = getwritepages("bb_id", _user)
				
		if(tables.nil?)
			return nil
		end
		
		result = connection.select_all("SELECT * FROM idx_pages WHERE #{tables};")

		return result
	end
	
	def self.getpage(_bb_id)
		return connection.select_one("SELECT * FROM idx_pages WHERE bb_id = '#{_bb_id}';")
	end
	
	def self.getinfo(_id)
		return connection.select_one("SELECT bb_id, bb_nm FROM idx_pages WHERE bb_id = '#{_id}';")
	end

end
