class TipoImpuesto < ActiveRecord::Base

    validates :descripcion,presence: true

end