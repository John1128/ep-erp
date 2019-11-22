class CreateRegimenFiscal < ActiveRecord::Migration[5.2]
  def change
    create_table :regimen_fiscals do |t|
      t.string :descripcion
      t.string :codigo_sat
      t.boolean :fisica
      t.boolean :moral
      t.timestamps
    end
  end
end
