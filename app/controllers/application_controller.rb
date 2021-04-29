class ApplicationController < ActionController::Base
	#test
	#protect_from_forgery with: :null_session
	protect_from_forgery with: :exception
	add_flash_types :error
	include SessionsHelper, ReportroomsHelper
	
	#수정 삭제 가능 시간 체크
	$modifytime = 2
	
	rescue_from ActionController::InvalidAuthenticityToken do |exception|
		sign_out # Example method that will destroy the user cookies
		redirect_to root_path
	end

end
