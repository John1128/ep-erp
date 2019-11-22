class CreateMunicipio < ActiveRecord::Migration[5.2]
  def change
    create_table :municipios do |t|
      t.string :nombre
      t.references :estado
    end
  end
end
