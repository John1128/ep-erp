class CreateTipoFactor < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_factors do |t|
      t.string :descripcion
    end
  end
end
