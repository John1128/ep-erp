class Cliente < ActiveRecord::Base

    validates :rfc, :razon_social, :email, presence: true

    belongs_to :municipio
    belongs_to :pais
end