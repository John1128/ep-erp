class Emisor < ActiveRecord::Base

    validates :rfc, :razon_social, :nombre_comercial, :email, presence: true

    belongs_to :municipio
end