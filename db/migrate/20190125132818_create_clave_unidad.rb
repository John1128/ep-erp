class CreateClaveUnidad < ActiveRecord::Migration[5.2]
  def change
    create_table :clave_unidads do |t|
      t.string :nombre
      t.string :clave
      t.string :codigo_sat
      t.string :simbolo
      t.timestamps
    end
  end
end
