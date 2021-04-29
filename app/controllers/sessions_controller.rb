class SessionsController < ApplicationController
	protect_from_forgery unless:  -> { request.format.json? }, only: [:new]
	 
	def create
		params = login_params
		
		user = IdxCcuId.GetUserInfo(params[:id], params[:pw])

		if user 
			authUser = IdxAuth.GetUserInfo(user)
			if singn_in(authUser)
				redirect_to index_main_path
			else
				flash[:error] = t :nouser
				redirect_to root_path
			end
		else
			flash[:error] = t :nouser
			redirect_to root_path
		end
	end
	
	def auto
		params = autologin_params
		
		token = params[:token]
		if token.nil?
			redirect_to root_path
		end
		
		token = remember_token_decrypt_and_verify(token)

		authUser = IdxAuth.GetUserInfo_byToken(token)
		if singn_in(authUser)
			redirect_to index_main_path
		else
			redirect_to root_path
		end
		
	end

	def destroy
		sign_out
		reset_session
		redirect_to root_path
	end
	
	private
    # Only allow a list of trusted parameters through.
    def login_params
    	params.require(:session).permit(:id, :pw)
    end
	
	def autologin_params
		params.require(:session).permit(:token)
	end
end
