class TestviewController < ApplicationController
	
	def login
	end
	
	def main
	end
	
	def value ##삭제코드
		render json: TbSfgshwng.getcompanylist
	end
end
