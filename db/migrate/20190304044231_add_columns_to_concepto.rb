class AddColumnsToConcepto < ActiveRecord::Migration[5.2]
  def change
    add_column :conceptos, :valor_unitario, :float, :null => true
    add_column :conceptos, :unidad_medida, :string, :null => true
    add_column :conceptos, :identificacion, :string, :null => true
  end
end
