class Concepto < ActiveRecord::Base

    validates :producto_id, :cantidad, :importe, :valor_unitario, :unidad_medida, presence: true

    belongs_to :factura
    belongs_to :producto
    belongs_to :clave_unidad
    has_many :concepto_impuestos

    accepts_nested_attributes_for :concepto_impuestos

end
