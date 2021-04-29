class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
	cattr_accessor :CUBE_JJ_ID, :SH_JJ_ID, instance_writer: false
	@@CUBE_JJ_ID = 'JJ01'.freeze	#큐브 에서 관리하는 자작 ID
	@@SH_JJ_ID = 'SH006'.freeze			#신화 에서 관리하는 자작 ID
	
	# 쓰기 가능한 테이블 조합
	def self.getwritepages(_type, _user)
		if( _user.nil? )
			return nil
		end
		tables = nil
		
		if(_user['P00'].downcase == 'w')		
			tables = "#{_type} = 'P00'"
		end
		
		if(_user['bb101'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb101'"
		end
		
		if(_user['bb102'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb102'"
		end
		
		if(_user['bb103'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb103'"
		end
		
		if(_user['bb104'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb104'"
		end
		
		if(_user['bb201'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb201'"
		end
		
		if(_user['bb202'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb202'"
		end
		
		if(_user['bb203'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb203'"
		end
		
		if(_user['bb204'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb204'"
		end
		
		if(_user['bb205'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb205'"
		end
			
		if(_user['bb206'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb206'"
		end
		
		if(_user['bb207'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb207'"
		end
		
		if(_user['bb208'].downcase == 'w')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb208'"
		end
		
		if(!tables.nil?)
			tables = "(#{tables})"
		end
		
		#puts "tables #{tables}"
		return tables
	end
	
	# 읽기 가능한 테이블 조합
	def self.getreadpages(_type, _user)
		if( _user.nil? )
			return nil
		end
		tables = nil
		
		auth = _user['P00'].downcase
		if(auth == 'w' || auth == 'r')		
			tables = "#{_type} = 'P00'"
		end
		
		auth = _user['bb101'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb101'"
		end
		
		auth = _user['bb102'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb102'"
		end
		
		auth = _user['bb103'].downcase 
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb103'"
		end
		
		auth = _user['bb104'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb104'"
		end
		
		auth = _user['bb201'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb201'"
		end
		
		auth = _user['bb202'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb202'"
		end
		
		auth = _user['bb203'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb203'"
		end
		
		auth = _user['bb204'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb204'"
		end
		
		auth = _user['bb205'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb205'"
		end
			
		auth = _user['bb206'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb206'"
		end
		
		auth = _user['bb207'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb207'"
		end
		
		auth = _user['bb208'].downcase
		if(auth == 'w' || auth == 'r')
			if(!tables.nil?)
				tables += " or "
			end
			tables += "#{_type} = 'bb208'"
		end
		
		if(!tables.nil?)
			tables = "(#{tables})"
		end
		
		#puts "tables #{tables}"
		return tables
	end
end
