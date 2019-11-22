class AddColumnsToFactura < ActiveRecord::Migration[5.2]
  def change
    add_reference :facturas, :regimen_fiscal, :null => true
    add_reference :facturas, :uso_cfdi, :null => true
    add_reference :facturas, :tipo_relacion, :null => true
    add_reference :facturas, :moneda, :null => true
    add_column :facturas, :total, :float, :null => true
    add_column :facturas, :subtotal, :float, :null => true
    add_column :facturas, :descuento, :float, :null => true
    add_column :facturas, :emisor_domicilio, :boolean, :null => true
    add_column :facturas, :receptor_domicilio, :boolean, :null => true
    add_column :facturas, :receptor_reg_trib, :string, :null => true
    add_column :facturas, :condicion_pago, :string, :null => true
    add_column :facturas, :notas_pie, :string, :null => true
    add_column :facturas, :cfdi_relacionado, :boolean, :null => true
    add_column :facturas, :folios_relacionados, :string, :null => true
  end
end
