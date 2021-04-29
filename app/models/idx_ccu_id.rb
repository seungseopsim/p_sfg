class IdxCcuId < ApplicationRecord

	
	def self.GetUserInfo(_id, _pw)
		return connection.select_one("SELECT idx_ccu_id FROM idx_ccu_id WHERE ccu_id = '%{id}' and ccu_pw = '%{pw}'; " % [id: _id, pw: _pw])
	end

end
