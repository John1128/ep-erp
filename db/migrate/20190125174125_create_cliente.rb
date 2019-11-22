class CreateCliente < ActiveRecord::Migration[5.2]
  def change
    create_table :clientes do |t|
      t.string :rfc
      t.string :razon_social
      t.string :telefono
      t.string :email
      t.references :municipio, :null => true
      t.string :colonia, :null => true
      t.string :codigo_postal, :null => true
      t.string :calle, :null => true
      t.string :numero_interior, :null => true
      t.string :numero_exterior, :null => true
      t.string :localidad, :null => true
      t.string :referencia, :null => true
      t.timestamps
    end
  end
end
