class AddFechadeCorteToFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :facturas, :fecha_corte, :date
  end
end
