class ConceptoImpuesto < ActiveRecord::Base

    validates :tipo_impuesto_id, :base, :impuesto_id, :tipo_factor_id, :tasa_cuota, :importe, presence: true

    belongs_to :concepto
    belongs_to :tipo_impuesto
    belongs_to :impuesto
    belongs_to :tipo_factor
   
    
end
