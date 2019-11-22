class ContentsController < ApplicationController

	rescue_from ActiveRecord::RecordNotFound, with: :render_404
    before_action :authenticate_user!
    
    def index
		@menu = "home"
	end
    

end