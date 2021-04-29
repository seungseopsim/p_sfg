class LivecheckController < ApplicationController
	protect_from_forgery unless:  -> { request.format.json? }, only: [:liveness_check, :readiness_check]
	
	def liveness_check
		head :ok
	end
	
	def readiness_check
        head :ok
    end
end