class CreateFactura < ActiveRecord::Migration[5.2]
  def change
    create_table :facturas do |t|
      t.references :tipo_comprobante
      t.references :emisor
      t.references :cliente
      t.integer :estatus
      t.references :forma_pago
      t.references :metodo_pago
      t.string :nota
      t.string :serie
      t.string :folio
      t.timestamps 
    end
  end
end