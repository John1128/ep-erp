class DomicilioFiscal < ActiveRecord::Base

    validates :municipio_id,:colonia,:codigo_postal,:calle,:localidad, presence: true

    belongs_to :municipio

    has_many :emisors, through: :emisor_domicilio_fiscal
    has_many :clientes, through: :cliente_domicilio_fiscal
end