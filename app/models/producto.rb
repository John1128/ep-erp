class Producto < ActiveRecord::Base

    validates :codigo_sat, :descripcion, presence: true

    
end