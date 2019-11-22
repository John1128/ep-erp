class ClaveUnidad < ActiveRecord::Base

    validates :nombre, :codigo_sat, presence: true

end