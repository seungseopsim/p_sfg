module FcmHelper
	
	@@FCM = FCM.new("AAAA4P1FHdw:APA91bEZUh3ZOnJHP2iX9c0FjxnSvmRggnSJ7XILhOP_8Im_5Cwk0YRRLXVFEUEAGvCBgpRgTB1XN9u6MepyU4hypm79OxclPDthplAWEcWqFTVbMTvF3KztwEzGqQcjpPwhWmnGOj7E")
	
	def sendpushtarget(_token, _title, _msg)
		if(_token.blank? || _msg.blank?)
			return false
		end

		response = @@FCM.send(_token, buildoption(_title, _msg))
				
		return response
	end
	
	def sendpushtargets(_tokenlist, _title, _msg)
		if(_tokenlist.blank? || _msg.blank?)
			return false
		end
		
		tokenlist = _tokenlist.map{ |token| token['msg_token'] }
=begin
		1000개 넘어가면 수정 바람
		(0...tokenlist.length).step(1000) do |n|
			first = 0
			last = n
			
			puts "first #{first} last #{last}"
		end
=end
		response = @@FCM.send(tokenlist, buildoption(_title, _msg))
		return response
	end

	def sendpushtopic(_topic, _title, _msg)
		if(_topic.blank? || _msg.blank?)
			return false
		end

		response = @@FCM.send_to_topic(_topic, buildoption(_title, _msg))		
		return response
	end
	
	private
	def buildoption(_title, _msg)
		options =  {
			priority: 'high',
			mutable_content: true,
			time_to_live: 172800, #2day
			
			data: {
				sendtime: Time.now
			},
	
			notification: {
				title: _title, 
				body: _msg,
				sound: 'default'
			}		
		}
		return options
	end
	
end
