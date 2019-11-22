class CreateProducto < ActiveRecord::Migration[5.2]
  def change
    create_table :productos do |t|
      t.string :codigo_sat
      t.string :descripcion
      t.timestamps
    end
  end
end
