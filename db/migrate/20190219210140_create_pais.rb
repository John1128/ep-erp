class CreatePais < ActiveRecord::Migration[5.2]
  def change
    create_table :pais do |t|
      t.string :nombre
      t.string :codigo_sat
    end
  end
end
