class CreateImpuesto < ActiveRecord::Migration[5.2]
  def change
    create_table :impuestos do |t|
      t.string :descripcion
      t.string :codigo_sat
    end
  end
end
