class IdxAuth < ApplicationRecord
	#before_create :create_remmeber_token
	
	@@col =  "idx_ccu_id, s_nm, ccu_nm, dpt_nm, bb_shoplist, P00, bb101, bb102, bb103, bb104, bb201, bb202, bb203, bb204, bb205, bb206, bb207, bb208, mlevel, plevel".freeze
	
	# user 
	def self.GetUserInfo(_userinfo)
		if _userinfo.nil?
			return nil
		end
		
		return connection.select_one("SELECT %{col} FROM idx_auth WHERE binary(idx_ccu_id) = '%{id}' AND mlevel != %{level}; " % [col: @@col, level: SessionsHelper::NOUSER, id: _userinfo['idx_ccu_id']])
	end
	
	def self.GetUserInfo_byToken(_token)
		if _token.nil?
			return nil
		end
		query = "SELECT %{col} FROM idx_auth WHERE remember_token = '%{token}' AND mlevel != %{level}; " % [ col: @@col, level: SessionsHelper::NOUSER, token: _token ]
		
		return connection.select_one(query)
	end
	
	# update token
	def self.updateToken(_userinfo, _token)
		
		if( _userinfo.nil? || _token.nil? )
			return
		end
		
		begin
			transaction do
				connection.update("UPDATE idx_auth SET remember_token = '%{token}' WHERE idx_ccu_id = '%{id}'; " % [token: _token, id: _userinfo['idx_ccu_id']])
			end
		rescue ActiveRecord::RecordInvalid => exception
			puts "Reportroom NewReport Error #{exception}"
			Rollback			
		end
	end
	
	#push token
	def self.updateMsgToken(_token, _msgtoken)
		result = false
		if(_msgtoken.nil?)
			return result
		end
		
		begin
			transaction do
				connection.update("UPDATE idx_auth SET msg_token = '%{msgtoken}' WHERE remember_token = '%{token}'; " % [msgtoken: _msgtoken, token: _token ])
				result = true
			end
		rescue ActiveRecord::RecordInvalid => exception
			puts "Reportroom NewReport Error #{exception}"
			Rollback
			result = false
		end
		return result	
	end
	
	# push tokens
	def self.getpushtargets(_id, _bbtype)
		return connection.select_all("SELECT msg_token FROM idx_auth WHERE (%{bbtype} = 'W' or %{bbtype} = 'R') AND (idx_ccu_id != '%{id}') AND msg_token IS NOT NULL " % [bbtype: _bbtype, id: _id] )
	end
	
	def self.FindbyToken(_token)
		return connection.select_one("SELECT %{col} FROM idx_auth WHERE remember_token = '%{token}'; " % [col: @@col, token: _token])
	end
	
	def self.new_remember_token
		SecureRandom.urlsafe_base64
	end
		
	def self.encrypt( token )
		Digest::SHA256.hexdigest( token.to_s )
	end
		
	private
	
	def create_remmeber_token
		self.remember_token = IdxAuth.encrypt(IdxAuth.new_remember_token)
	end

end
