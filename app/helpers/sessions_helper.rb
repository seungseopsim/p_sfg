module SessionsHelper
	VIP = 40			# 최고 관리자
	GM = 30				# 임원
	GROUP = 22			# 그룹
	SHOP = 21			# 업장
	USER = 10			# 보고방
	NOUSER = 0			# 로그인 불가
	
	CRYPT = ActiveSupport::MessageEncryptor.new( ENV["SECRET_KEY_BASE"].nil? ? Rails.application.secrets.secret_key_base[0..31] : ENV["SECRET_KEY_BASE"][0..31])
	
	#로그인시 세션 토큰을 만들고 쿠키에 저장
	def singn_in(_user)
		if(_user.nil?)
			return false
		end
		
		sign_out
		remember_token = IdxAuth.new_remember_token
		
		securemode = false
		if Rails.env.production?
			securemode = true
		end
		
		cookies[:token] ={
			value: Base64.encode64(CRYPT.encrypt_and_sign(remember_token, expires_in: 1.year)),
			expires: 1.year,
			secure: securemode		
		} 
		IdxAuth.updateToken(_user, remember_token)
		self.current_user = _user
		session[:remember_token] = remember_token
		session[:userkey] = _user['idx_ccu_id']
		return true
	end
	
	#로그인했는지 여부
	def signed_in?
		#puts "UserInfo #{current_user}"
		!current_user.nil?
	end
	
	#이후의 페이지에서 세션토큰을 위해서 사용자 정보를 가져온다
	def current_user=(_user)
		@current_user = _user
	end
	
	def userkey 
		return session[:userkey]
	end
	
	#쿠키에 저장된 토큰을 가져와서 사용한다. 
	def current_user
		remember_token = session[:remember_token]
		if(remember_token.nil?)
			return nil
		end

		@current_user ||= IdxAuth.FindbyToken(remember_token)
	end
	
	#로그 아웃 처리
	def sign_out
		self.current_user = nil
		session.delete(:remember_token)
		session.delete(:userkey)
		cookies.delete(:token)
	end
	
	def checkuser
		unless signed_in?
			redirect_to root_path
		end
	end
	
	#remember_token 해제 처리	
	def remember_token_decrypt_and_verify(_token)
		if _token.nil?
			return nil
		end
		begin
			token = CRYPT.decrypt_and_verify(Base64.decode64(_token))
		rescue => exception
			token = nil
			Rails.logger.error "SessionsHelper remember_token_decrypt_and_verify error #{exception}"
		end
		return token
	end
	
	#-------------------------------------------------------------------------------------------------------
	# 등급 권한
	#-------------------------------------------------------------------------------------------------------
	def isVIP
		return level == VIP
	end
	def	isGM
		return level == GM
	end
	def isGROUP
		return level == GROUP
	end
	def isSHOP
		return level == SHOP
	end
	def isUSER
		return level == USER
	end
	
	#-------------------------------------------------------------------------------------------------------
	# 별도 권한 (추가시 알아서)
	# 게시판 삭제 기눙
	#-------------------------------------------------------------------------------------------------------
	def isPUser
		return plevel == 10
	end
	#-------------------------------------------------------------------------------------------------------
	#등급 권한
	#-------------------------------------------------------------------------------------------------------
		
	#-------------------------------------------------------------------------------------------------------
	# 게시판 읽기 권한
	#-------------------------------------------------------------------------------------------------------
	def readP00?
		auth = current_user['P00'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb101?
		auth = current_user['bb101'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb102?
		auth = current_user['bb102'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb103?	
		auth = current_user['bb103'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb104?	
		auth = current_user['bb104'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb201?	
		auth = current_user['bb201'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb202?	
		auth = current_user['bb202'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb203?	
		auth = current_user['bb203'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb204?	
		auth = current_user['bb204'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb205?	
		auth = current_user['bb205'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb206?	
		auth = current_user['bb206'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb207?	
		auth = current_user['bb207'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	def readbb208?	
		auth = current_user['bb208'].downcase
		if( auth == 'w' || auth == 'r')
			return true
		end
		
		return false
	end
	
	#-------------------------------------------------------------------------------------------------------
	#게시판 읽기 권한
	#-------------------------------------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------------------------------------
	# 게시판 읽기/쓰기
	#-------------------------------------------------------------------------------------------------------
	def writeP00?
		auth = current_user['P00'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb101?
		auth = current_user['bb101'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb102?
		auth = current_user['bb102'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb103?	
		auth = current_user['bb103'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb104?	
		auth = current_user['bb104'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb201?	
		auth = current_user['bb201'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb202?	
		auth = current_user['bb202'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb203?	
		auth = current_user['bb203'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb204?	
		auth = current_user['bb204'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb205?	
		auth = current_user['bb205'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb206?	
		auth = current_user['bb206'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb207?	
		auth = current_user['bb207'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
	
	def readbb208?	
		auth = current_user['bb208'].downcase
		if( auth == 'w' )
			return true
		end
		
		return false
	end
		
	private
		
	def level
		unless !signed_in?
			return current_user['mlevel']
		end
	end
	
	def plevel
		unless !signed_in?
			return current_user['plevel']
		end
	end
end
