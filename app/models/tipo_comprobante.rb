class TipoComprobante < ActiveRecord::Base

    validates :descripcion, presence: true

end