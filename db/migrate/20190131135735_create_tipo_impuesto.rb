class CreateTipoImpuesto < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_impuestos do |t|
      t.string :descripcion
    end
  end
end
