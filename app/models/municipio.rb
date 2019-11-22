class Municipio < ActiveRecord::Base

    validates :nombre, :estado_id, presence: true

    belongs_to :estado
    has_many :domicilio_fiscals

end