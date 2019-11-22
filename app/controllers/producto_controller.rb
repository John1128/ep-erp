class ProductoController < ApplicationController

	rescue_from ActiveRecord::RecordNotFound, with: :render_404
    before_action :authenticate_user!
    
    def index
		
    end
    
    def show
        @producto = Producto.find(params[:id])
        render json: @producto
    end
    

end