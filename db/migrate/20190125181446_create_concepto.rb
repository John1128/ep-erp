class CreateConcepto < ActiveRecord::Migration[5.2]
  def change
    create_table :conceptos do |t|
      t.references :factura
      t.references :producto
      t.references :clave_unidad
      t.integer :cantidad
      t.float :importe
      t.float :descuento
      t.timestamp
    end
  end
end
