class ClienteController < ApplicationController

	rescue_from ActiveRecord::RecordNotFound, with: :render_404
    before_action :authenticate_user!
    
    def index
		
    end
    
    def show
        @client = Cliente.find(params[:id])
        render json: @client
    end
    

end