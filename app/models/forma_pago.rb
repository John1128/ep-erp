class FormaPago < ActiveRecord::Base

    validates :descripcion, :codigo_sat, presence: true

end