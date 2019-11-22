class Factura < ActiveRecord::Base

    enum estatus: [:guardado, :timbrado,:cancelado]

    validates :tipo_comprobante_id, :emisor_id, :cliente_id, :estatus, :forma_pago_id, :metodo_pago_id, presence: true

    belongs_to :emisor
    belongs_to :cliente
    belongs_to :tipo_comprobante
    belongs_to :forma_pago
    belongs_to :metodo_pago
    belongs_to :regimen_fiscal
    belongs_to :uso_cfdi
    belongs_to :tipo_relacion, optional: true
    belongs_to :moneda, optional: true
    has_many :conceptos

    accepts_nested_attributes_for :conceptos

    def self.last_folio
        if self.last then self.last.folio.to_i + 1 else 1 end
    end

end
