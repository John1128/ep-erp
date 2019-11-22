class AddPaisToCliente < ActiveRecord::Migration[5.2]
  def change
    add_reference :clientes, :pais, :null => true
  end
end
