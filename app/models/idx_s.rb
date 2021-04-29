class IdxS < ApplicationRecord
	
	def self.selectinfo
		return connection.select_all("SELECT s_id, s_nm_short FROM idx_s WHERE s_sort >= 100 ORDER BY s_sort ASC;")
	end

end