class Cubedb::CubeDbBase 

	# select one
	def self.execute_one(query)	
		result = nil
		
		begin
			client = connect
			if client.nil?
				return result
			end
			
			puts "query #{query}"
			queryresult = client.execute(query)

			queryresult.each do |row|
				result = row
			end
			#Rails.logger.debug "rows #{queryresult.affected_rows}"
			puts "rows #{queryresult.affected_rows}"
		rescue TinyTds::Error => exception
			#Rails.logger.error "Cubedb::CubeDbBase Error #{exception}"
			puts "Cubedb::CubeDbBase Error #{exception}"
		ensure
			queryresult = nil
			if !client.nil?
				client.close
				client = nil
			end
		end
		
		#@@client.close
		return result
	end
	
	def self.execute_all(query)	
		result = nil
		
		begin
			client = connect
			if client.nil?
				return result
			end
			
			puts "query #{query}"
			queryresult = client.execute(query)
				
			result = Array.new()
			
			queryresult.each do |row|
				result.push(row)
			end
			#Rails.logger.debug "rows #{queryresult.affected_rows}"
			puts "rows #{queryresult.affected_rows}"
		rescue TinyTds::Error => exception
			#Rails.logger.error "Cubedb::CubeDbBase Error #{exception}"
			puts "Cubedb::CubeDbBase Error #{exception}"
		ensure
			queryresult = nil
			if !client.nil?
				client.close
				client = nil
			end
		end
		
		#@@client.close
		return result
	end
	
	private
	
	def self.connect
		client = nil
		begin
			client = TinyTds::Client.new username: 'sh_mappif', password: 'shmappif20@)',  host: '182.162.136.249', port: 1198, database: 'CUBECENTER', timeout: 60
		rescue  TinyTds::Error => exception
			#Rails.logger.error "Cubedb::CubeDbBase Error #{exception}"
			puts "Cubedb::CubeDbBase Error #{exception}"
		end
		
		return client
	end
	
end