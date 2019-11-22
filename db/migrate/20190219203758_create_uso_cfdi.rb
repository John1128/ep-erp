class CreateUsoCfdi < ActiveRecord::Migration[5.2]
  def change
    create_table :uso_cfdis do |t|
      t.string :descripcion
      t.string :codigo_sat
    end
  end
end
