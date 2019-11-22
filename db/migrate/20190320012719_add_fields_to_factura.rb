class AddFieldsToFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :facturas, :uuid, :string, :null => true
    add_column :facturas, :pdf_url, :string, :null => true
    add_column :facturas, :xml_url, :string, :null => true
    add_column :facturas, :cancelada, :datetime, :null => true
    add_column :facturas, :justificacion, :string, :null => true
  end
end
