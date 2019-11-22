class CreateConceptoImpuesto < ActiveRecord::Migration[5.2]
  def change
    create_table :concepto_impuestos do |t|
      t.references :concepto
      t.references :tipo_impuesto
      t.float :base, :null => true
      t.references :impuesto
      t.references :tipo_factor
      t.float :tasa_cuota, :null => true
      t.float :importe, :null => true
    end
  end
end
